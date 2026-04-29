import os
import glob

svg_dir = 'assets/Service Icon svg'
svg_files = glob.glob(os.path.join(svg_dir, '*.svg'))

for file_path in svg_files:
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    content = content.replace('class="st0"', 'fill="#102A6B"')
    content = content.replace('class="st1"', 'fill="#102A6B"')
    content = content.replace('class="st2"', 'fill="#102A6B"')
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
        
print("Updated all SVGs.")
