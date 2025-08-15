#!/usr/bin/env rust-script

use std::fs;
use std::path::PathBuf;
use std::process::Command;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let xcode_path = get_xcode_path()?;
    let xcode_font_path = xcode_path.join("Contents/SharedFrameworks/DVTUserInterfaceKit.framework/Resources/FontAndColorThemes");
    
    let home = std::env::var("HOME")?;
    let user_font_path = PathBuf::from(home).join("Library/Developer/Xcode/UserData/FontAndColorThemes");
    fs::create_dir_all(&user_font_path)?;
    
    println!("Copying default color themes...");
    
    let themes_to_copy = [
        "Default (Light).xccolortheme",
        "Default (Dark).xccolortheme", 
        "Presentation Large (Light).xccolortheme",
        "Presentation Large (Dark).xccolortheme",
    ];
    
    for theme in &themes_to_copy {
        let src = xcode_font_path.join(theme);
        let dst = user_font_path.join(theme);
        fs::copy(&src, &dst)?;
        println!("Copied: {}", theme);
    }
    
    println!("Processing font themes...");
    
    process_theme(
        &user_font_path.join("Default (Light).xccolortheme"),
        &user_font_path.join("usami (Light).xccolortheme"),
        false,
    )?;
    
    process_theme(
        &user_font_path.join("Default (Dark).xccolortheme"),
        &user_font_path.join("usami (Dark).xccolortheme"),
        false,
    )?;
    
    process_theme(
        &user_font_path.join("Presentation Large (Light).xccolortheme"),
        &user_font_path.join("usami Presentation (Light).xccolortheme"),
        true,
    )?;
    
    process_theme(
        &user_font_path.join("Presentation Large (Dark).xccolortheme"),
        &user_font_path.join("usami Presentation (Dark).xccolortheme"),
        true,
    )?;
    
    println!("Font theme processing completed!");
    Ok(())
}

fn get_xcode_path() -> Result<PathBuf, Box<dyn std::error::Error>> {
    let output = Command::new("xcode-select")
        .arg("--print-path")
        .output()?;
    
    if !output.status.success() {
        return Err("Failed to get Xcode path".into());
    }
    
    let path_str = String::from_utf8(output.stdout)?;
    let path = PathBuf::from(path_str.trim());

    // xcode-select では Developer ディレクトリが得られるので、2つ上のディレクトリを返す
    Ok(path.parent().unwrap().parent().unwrap().to_path_buf())
}

fn process_theme(input_path: &PathBuf, output_path: &PathBuf, is_large: bool) -> Result<(), Box<dyn std::error::Error>> {
    let content = fs::read_to_string(input_path)?;
    let lines: Vec<String> = content.lines().map(|s| s.to_string()).collect();
    
    let processed = if is_large {
        process_large_font_lines(lines)
    } else {
        process_normal_font_lines(lines)
    };
    
    let mut output_content = String::new();
    for line in processed {
        output_content.push_str(&line);
        output_content.push('\n');
    }
    
    fs::write(output_path, output_content)?;
    println!("Generated: {}", output_path.file_name().unwrap().to_string_lossy());
    Ok(())
}

fn process_normal_font_lines(lines: Vec<String>) -> Vec<String> {
    let mut result = Vec::new();
    let mut i = 0;
    
    while i < lines.len() {
        let mut line = lines[i].clone();
        
        if line.contains("DVTLineSpacing") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("1.1000000238418579", "1.2000000476837158");
                result.push(line);
            }
        } else if line.contains("DVTConsole") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("SFMono-Regular - 12.0", "0xProto-Regular - 12.0");
                result.push(line);
            }
        } else if line.contains("xcode.syntax.comment") || line.contains("xcode.syntax.mark") || line.contains("xcode.syntax.string") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("SFMono-Regular - 12.0", "BIZUDGothic-Regular - 14.0");
                line = line.replace("SFMono-Medium - 12.0", "BIZUDGothic-Regular - 14.0");
                line = line.replace("SFMono-Semibold - 12.0", "BIZUDGothic-Bold - 14.0");
                line = line.replace("SFMono-Bold - 12.0", "BIZUDGothic-Bold - 14.0");
                line = line.replace("Helvetica - 12.0", "BIZUDMincho-Regular - 14.0");
                line = line.replace("HelveticaNeue - 12.0", "BIZUDMincho-Regular - 14.0");
                result.push(line);
            }
        } else {
            line = line.replace("SFMono-Regular - 12.0", "0xProto-Regular - 14.0");
            line = line.replace("SFMono-Medium - 12.0", "0xProto-Regular - 14.0");
            line = line.replace("SFMono-Semibold - 12.0", "0xProto-Bold - 14.0");
            line = line.replace("SFMono-Bold - 12.0", "0xProto-Bold - 14.0");
            result.push(line);
        }
        
        i += 1;
    }
    
    result
}

fn process_large_font_lines(lines: Vec<String>) -> Vec<String> {
    let mut result = Vec::new();
    let mut i = 0;
    
    while i < lines.len() {
        let mut line = lines[i].clone();
        
        if line.contains("DVTLineSpacing") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("1.1000000238418579", "1.2000000476837158");
                result.push(line);
            }
        } else if line.contains("DVTConsole") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("SFMono-Regular - 18.0", "0xProto-Regular - 18.0");
                result.push(line);
            }
        } else if line.contains("xcode.syntax.comment") || line.contains("xcode.syntax.mark") || line.contains("xcode.syntax.string") {
            result.push(line);
            i += 1;
            if i < lines.len() {
                line = lines[i].clone();
                line = line.replace("SFMono-Regular - 28.0", "BIZUDGothic-Regular - 28.0");
                line = line.replace("SFMono-Medium - 28.0", "BIZUDGothic-Regular - 28.0");
                line = line.replace("SFMono-Semibold - 28.0", "BIZUDGothic-Bold - 28.0");
                line = line.replace("SFMono-Bold - 28.0", "BIZUDGothic-Bold - 28.0");
                line = line.replace("Helvetica - 28.0", "BIZUDMincho-Regular - 28.0");
                line = line.replace("HelveticaNeue - 28.0", "BIZUDMincho-Regular - 28.0");
                result.push(line);
            }
        } else {
            line = line.replace("SFMono-Regular - 28.0", "0xProto-Regular - 28.0");
            line = line.replace("SFMono-Medium - 28.0", "0xProto-Regular - 28.0");
            line = line.replace("SFMono-Semibold - 28.0", "0xProto-Bold - 28.0");
            line = line.replace("SFMono-Bold - 28.0", "0xProto-Bold - 28.0");
            result.push(line);
        }
        
        i += 1;
    }
    
    result
}
