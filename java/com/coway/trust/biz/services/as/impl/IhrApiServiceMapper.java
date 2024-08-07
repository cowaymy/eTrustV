package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------
 * 05/09/2019    ONGHC      1.0.1       - CREATE FOR IN-HOUSE REPAIR
 * 17/12/2019    ONGHC      1.0.2       - Add AS Used Filter Feature
 *********************************************************************************************/

@Mapper("IhrApiServiceMapper")
public interface IhrApiServiceMapper {

	List<EgovMap> selectSyncIhr(Map<String, Object> params);
}
