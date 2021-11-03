package org.zerock.mapper;

import java.util.HashMap;
import java.util.List;

import org.zerock.domain.HeritageVO;



public interface HeritageMapper {

	public List<HashMap<String, String>> loadList(String name);

	public List<HashMap<String, String>> loadOneHeritage(String name);

	public List<HeritageVO> getAllList();

	}