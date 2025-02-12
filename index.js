require("dotenv").config();
const express = require("express");
const AWS = require("aws-sdk");
const axios = require("axios");
const { v4: uuidv4 } = require("uuid");

const app = express();
const PORT = process.env.PORT || 80;

const s3 = new AWS.S3();
const BUCKET_NAME = process.env.S3_BUCKET_NAME;


app.get("/generateGif", async (req, res) => {
    try {

        const response = await axios.get("https://api.thecatapi.com/v1/images/search", {
            headers: { "x-api-key": process.env.CAT_API_KEY },
            params: { mime_types: "gif", size: "med" },
        });

        if (response.data.length === 0) {
            return res.status(404).json({ error: "No cat GIF found" });
        }

        const gifUrl = response.data[0].url;
        const gifResponse = await axios.get(gifUrl, { responseType: "arraybuffer" });

        let uuid = req.query.uuid ? req.query.uuid : uuidv4();
        const fileName = `cat-gifs/${uuid}.gif`;
        await s3
            .putObject({
                Bucket: BUCKET_NAME,
                Key: fileName,
                Body: gifResponse.data,
                ContentType: "image/gif",
                ServerSideEncryption: "AES256",
            })
            .promise();

        const signedUrl = s3.getSignedUrl("getObject", {
            Bucket: BUCKET_NAME,
            Key: fileName,
            Expires: 3600,
        });

        res.json({ message: "GIF uploaded successfully!", signedUrl });
    } catch (error) {
        console.error("Error uploading GIF:", error);
        res.status(500).json({ error: "Failed to upload cat GIF" });
    }
});

app.get("/gif/:id", async (req, res) => {
    try {

        let uuid = req.params.id;
        const fileName = `cat-gifs/${uuid}.gif`;

        const signedUrl = s3.getSignedUrl("getObject", {
            Bucket: BUCKET_NAME,
            Key: fileName,
            Expires: 3600,
        });

        res.json({ message: "enjoy cat GIF", signedUrl });
    } catch (error) {
        console.error("Error fetching latest GIF:", error);
        res.status(500).json({ error: "Failed to fetch latest GIF" });
    }
});

app.get("/latest-gif", async (req, res) => {
    try {

        const objects = await s3
            .listObjectsV2({
                Bucket: BUCKET_NAME,
                Prefix: "cat-gifs/",
            })
            .promise();

        if (!objects.Contents.length) {
            return res.status(404).json({ error: "No GIFs found in the bucket" });
        }

        const latestGif = objects.Contents.toSorted((a, b) => b.LastModified - a.LastModified)[0];

        const signedUrl = s3.getSignedUrl("getObject", {
            Bucket: BUCKET_NAME,
            Key: latestGif.Key,
            Expires: 3600,
        });

        res.json({ signedUrl });
    } catch (error) {
        console.error("Error fetching latest GIF:", error);
        res.status(500).json({ error: "Failed to fetch latest GIF" });
    }
});

app.get("/health-check", (req, res) => {
    res.sendStatus(200);
});

app.get("/send-error", (req, res) => {
    try {

        throw new Error(`ERROR = ${req.query.error}`);
    } catch (error) {
        console.error({
            "level": "ERROR",
            "message": error.message
        })
        res.sendStatus(500);
    }
});


app.listen(PORT, () => console.log(`🚀 Server running at http://localhost:${PORT}`));