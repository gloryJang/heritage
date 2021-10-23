package org.zerock.service;

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
	public List<HashMap<String, String>> loadOneInfo(String name) {
		
		log.info("문화재 상세 정보 가져오기 : " + name);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("name", name);
		
		return mapper.loadOneInfo(name);
	}
}
