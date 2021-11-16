package org.zerock.service;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.HeritageVO;
import org.zerock.mapper.HeritageMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class HeritageServiceImpl implements HeritageService {

	@Setter(onMethod_ = @Autowired)
	private HeritageMapper mapper;

	@Override
	public List<HashMap<String, String>> loadList(String name, String condition) {

		log.info("파라미터 매퍼 전 : " + name + ", " + condition);

		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("name", name);
		paramMap.put("condition", condition);

		return mapper.loadList(paramMap);
	}

	@Override
	public List<HashMap<String, String>> loadOneHeritage(String name) {

		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("name", name);

		return mapper.loadOneHeritage(name);
	}

	@Override
	public List<HeritageVO> getAllList() {
		
		return mapper.getAllList();
	}
	
	
}
