package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("transferMapper")
public interface TransferMapper {

	List<EgovMap> selectMemberLevel(Map<String, Object> params);
	
	List<EgovMap> selectFromTransfer(Map<String, Object> params);
	
	List<EgovMap> selectTransferList(Map<String, Object> params);
}
