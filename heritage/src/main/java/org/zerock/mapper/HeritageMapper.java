package org.zerock.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.zerock.domain.HeritageVO;



public interface HeritageMapper {

	public List<HashMap<String, String>> loadList(Map<String, Object> paramMap);

	public List<HashMap<String, String>> loadOneHeritage(String name);

	public List<HeritageVO> getAllList();

	}