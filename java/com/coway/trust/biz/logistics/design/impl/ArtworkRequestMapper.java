package com.coway.trust.biz.logistics.design.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("artworkMapper")
public interface ArtworkRequestMapper {
	List<EgovMap> selectArtworkCategoryList(Map<String, Object> params);		
	
	List<EgovMap> selectArtworkList(Map<String, Object> params);
}
