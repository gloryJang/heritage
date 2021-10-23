package org.zerock.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.service.HeritageService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/heritage/*")
@AllArgsConstructor
public class HeritageController {
	
	private HeritageService service;
	
	@GetMapping("")
	public String main() {
		
		log.info("main 실행");
		
	return "/heritage/main";
	}
	
	@GetMapping("/load")
	public ResponseEntity<List<HashMap<String, String>>> load(@RequestParam("name") String name)
	{
		log.info("문화재 이름 입력 : " + name);
		
		ResponseEntity<List<HashMap<String, String>>> entity = null;
	    try{
	        entity = new ResponseEntity<>(service.loadOneInfo(name), HttpStatus.OK);
	    } catch(Exception e){
	        e.printStackTrace();
	        entity = new ResponseEntity<>( HttpStatus.BAD_REQUEST );
	    }
	 
	    return entity;
	}
}
