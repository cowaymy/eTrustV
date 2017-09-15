package com.coway.trust.biz.sales.order;

import java.text.ParseException;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OrderModifyService {

	void updateOrderBasinInfo(Map<String, Object> params, SessionVO sessionVO);

	EgovMap selectBillGrpMailingAddr(Map<String, Object> params) throws Exception;

	void updateOrderMailingAddress(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap selectBillGrpCntcPerson(Map<String, Object> params) throws Exception;

	void updateCntcPerson(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap checkNricEdit(Map<String, Object> params) throws Exception;

	EgovMap selectCustomerInfo(Map<String, Object> params) throws Exception;

	EgovMap checkNricExist(Map<String, Object> params) throws Exception;

	void updateNric(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

}
