package org.zerock.service;

import java.util.HashMap;
import java.util.List;

import org.zerock.domain.HeritageVO;


public interface HeritageService {

	public List<HashMap<String, String>> loadList(String name, String condition);

	public List<HashMap<String, String>> loadOneHeritage(String name);

	public List<HeritageVO> getAllList();

}
