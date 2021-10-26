package org.zerock.mapper;

import java.util.HashMap;
import java.util.List;



public interface HeritageMapper {

	public List<HashMap<String, String>> loadList(String name);

	public List<HashMap<String, String>> loadOneHeritage(String name);

	}