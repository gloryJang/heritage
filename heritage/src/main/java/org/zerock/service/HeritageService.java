package org.zerock.service;

import java.util.HashMap;
import java.util.List;


public interface HeritageService {

	public List<HashMap<String, String>> loadList(String name);

	public List<HashMap<String, String>> loadOneHeritage(String name);

}
