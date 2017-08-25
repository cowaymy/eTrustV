package com.coway.trust.biz.logistics.helpdesk.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("HelpDeskMapper")
public interface HelpDeskMapper {

	List<EgovMap> selectDataChangeList(Map<String, Object> params);
	
	List<EgovMap> detailDataChangeList(Map<String, Object> params);
/*	int selectSirimNo(Map<String, Object> params);
	
	int SirimMCreateSeq();
	int SirimDCreateSeq();
	int CrdPosCreateSeq();
	String docNoCreateSeq();
	
	void insertSirimM(Map<String, Object> params);
	void insertSirimD(Map<String, Object> params);
	void insertSirimCrd_Pos(Map<String, Object> params);*/
	
}
