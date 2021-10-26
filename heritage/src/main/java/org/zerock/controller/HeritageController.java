package org.zerock.controller;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

import java.util.HashMap;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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

		log.info("main ï¿½ï¿½ï¿½ï¿½");

	return "/heritage/main";
	}

	@GetMapping("/loadList")
	public ResponseEntity<List<HashMap<String, String>>> loadList(@RequestParam("name") String name)
	{
		log.info("ï¿½ï¿½È­ï¿½ï¿½ ï¿½Ì¸ï¿½ ï¿½Ô·ï¿½ : " + name);

		ResponseEntity<List<HashMap<String, String>>> entity = null;
	    try{
	        entity = new ResponseEntity<>(service.loadList(name), HttpStatus.OK);
	    } catch(Exception e){
	        e.printStackTrace();
	        entity = new ResponseEntity<>( HttpStatus.BAD_REQUEST );
	    }

	    return entity;
	}
	
	@GetMapping("/loadOneHeritage")
	public ResponseEntity<List<HashMap<String, String>>> loadHeitage(@RequestParam("name") String name)
	{
		log.info("ÇÏ³ªÀÇ ¹®È­Àç Á¤º¸ ºÒ·¯¿À±â : " + name);

		ResponseEntity<List<HashMap<String, String>>> entity = null;
	    try{
	        entity = new ResponseEntity<>(service.loadOneHeritage(name), HttpStatus.OK);
	    } catch(Exception e){
	        e.printStackTrace();
	        entity = new ResponseEntity<>( HttpStatus.BAD_REQUEST );
	    }

	    return entity;
	}
	
}
