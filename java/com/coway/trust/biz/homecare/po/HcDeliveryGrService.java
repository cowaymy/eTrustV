package com.coway.trust.biz.homecare.po;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface HcDeliveryGrService {

	// main List 조회
	public int selectDeliveryGrMainCnt(Map<String, Object> params) throws Exception;
	public List<EgovMap> selectDeliveryGrMain(Map<String, Object> params) throws Exception;

	public List<EgovMap> selectDeliveryConfirm(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// GR처리
	public int multiHcDeliveryGr(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// Grid - GR처리
	public int multiGridGr(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception;

	// 진행중인 Serial 초기화
	public int clearIngSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	// serial use Yn check
	public String selectLocationSerialChk(Map<String, Object> obj) throws Exception;
}