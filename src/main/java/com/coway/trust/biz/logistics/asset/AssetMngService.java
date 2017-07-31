package com.coway.trust.biz.logistics.asset;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;


public interface AssetMngService {
	
	List<EgovMap>selectAssetList(Map<String, Object> params);	
	
}
