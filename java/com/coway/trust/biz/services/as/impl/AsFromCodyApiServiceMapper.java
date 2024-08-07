package com.coway.trust.biz.services.as.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/*********************************************************************************************
 * DATE          PIC        VERSION     COMMENT
 *--------------------------------------------------------------------------------------------

 *********************************************************************************************/

@Mapper("asFromCodyApiServiceMapper")
public interface AsFromCodyApiServiceMapper {

	int insertAsFromCodyRequest(Map<String, Object> params);

	EgovMap selectSubmissionRecords(Map<String, Object> params);

	EgovMap selectOrderInfo(Map<String, Object> params);

	List<EgovMap> selectSubmissionRecordsAll(Map<String, Object> params);

}
