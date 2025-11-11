from cog import BasePredictor,Input
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer,pipeline

class Predictor(BasePredictor):
    def setup(self):
        self.tokenizer = AutoTokenizer.from_pretrained("Qwen/Qwen3-4B-Instruct-2507")
        self.model = AutoModelForCausalLM.from_pretrained("Qwen/Qwen3-4B-Instruct-2507",torch_dtype=torch.bfloat16, device_map="auto")
        self.sql_generator = pipeline(
            task="text-generation",
            model=self.model,
            tokenizer=self.tokenizer,
            do_sample=False,
            temperature=0.0
        )

    def predict(self,user_input: str = Input(description="Prompt")) -> str:
        messages = [
            {"role": "user", "content": user_input}
        ]
        text = self.tokenizer.apply_chat_template(
            messages,
            tokenize=False,
            add_generation_prompt=True,
        )
        model_inputs = self.tokenizer([text], return_tensors="pt").to(self.model.device)
        with torch.no_grad():
            generated_ids = self.model.generate(
                **model_inputs,
                max_new_tokens=16384)
        output_ids = generated_ids[0][len(model_inputs.input_ids[0]):].tolist() 
        content = self.tokenizer.decode(output_ids, skip_special_tokens=True)
        return{content.strip()}
        