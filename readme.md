docker build -t openai .

RUN openai tools fine_tunes.prepare_data -f "training-data.json"

docker run -td -p 8080:8080 openai

docker ps -l

ft-XPvCeAjV6HgIlaxLVTEb7ilQ

=====
1. ## CLI data preparation tool ##
```openai tools fine_tunes.prepare_data -f <LOCAL_FILE>```
openai tools fine_tunes.prepare_data -f data.json

==> generates the file: data_prepared.jsonl

2. ## List uploaded files ##
```
curl https://api.openai.com/v1/files \
-H "Authorization: Bearer $OPENAI_API_KEY"
```

3. ## Upload a file ##
```
curl https://api.openai.com/v1/files \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -F purpose="fine-tune" \
  -F file="@data_prepared.jsonl"
```
==> "id": "file-P36evIMYJJe6f6aUkwdwwOTu",

4. ## Create fine-tune form uploaded file ##
```
curl https://api.openai.com/v1/fine-tunes \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
    "training_file": "file-P36evIMYJJe6f6aUkwdwwOTu",
    "model": "davinci"
  }'
```
==> "message": "Created fine-tune: ft-qTrI4mF46o3z9VIZXRDL6jDV"
==> if no model selected, then the default value is "model": "curie"

// It will take some time to be processed, you can check the status as: "status": "pending",
5. ## List fine-tunes ##
```
curl https://api.openai.com/v1/fine-tunes \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

6. Follow the status of the fine tune
```
openai api fine_tunes.follow -i <YOUR_FINE_TUNE_JOB_ID>
openai api fine_tunes.follow -i "ft-qTrI4mF46o3z9VIZXRDL6jDV"
```
Job complete! Status: succeeded 🎉
Try out your fine-tuned model:

openai api completions.create -m davinci:ft-personal-2023-04-06-20-34-49 -p <YOUR_PROMPT>

openai api completions.create -m davinci:ft-personal-2023-04-06-20-34-49 -p "The stock value of item XYZ is"

6. ## Use a fine-tuned model ##
```
curl https://api.openai.com/v1/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": YOUR_PROMPT, "model": FINE_TUNED_MODEL}'
```

curl https://api.openai.com/v1/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "The stock value of item XYZ is ->", "model": "davinci:ft-personal-2023-04-06-20-34-49",
    "stop": "[DONE]"
    }'

5. ## Delete a fine-tuned model ##
curl -X "DELETE" https://api.openai.com/v1/models/<FINE_TUNED_MODEL> \
  -H "Authorization: Bearer $OPENAI_API_KEY"

curl -X "DELETE" https://api.openai.com/v1/models/curie:ft-personal-2023-04-06-19-23-06 \
-H "Authorization: Bearer $OPENAI_API_KEY"



6. ## Delete fine-tune model ##
``` // model:id
curl https://api.openai.com/v1/models/davinci:ft-personal-2023-04-06-08-08-48 \
  -X DELETE \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

7. ## List fine-tune events ##
```bash
curl https://api.openai.com/v1/fine-tunes/ft-3sZKrPPBn0Jr1zMxvufw6mTT/events \
  -H "Authorization: Bearer $OPENAI_API_KEY"
  ```

8. ## Delete file ##
```
curl https://api.openai.com/v1/files/file-oyG8W7B2JiZOid5GcvdYSDX5 \
  -X DELETE \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```