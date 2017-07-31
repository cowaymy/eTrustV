package com.coway.trust.biz.logistics.asset.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("AssetMngMapper")
public interface AssetMngMapper {
	List<EgovMap> selectAssetList(Map<String, Object> params);

}
