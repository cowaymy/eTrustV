package com.coway.trust.biz.homecare.sales;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.OrderModifyVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface htOrderModifyService {

	void updateOrderBasinInfo(Map<String, Object> params, SessionVO sessionVO);

	EgovMap selectBillGrpMailingAddr(Map<String, Object> params) throws Exception;

	void updateOrderMailingAddress(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap selectBillGrpCntcPerson(Map<String, Object> params) throws Exception;

	void updateCntcPerson(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap checkNricEdit(Map<String, Object> params) throws Exception;

	EgovMap selectCustomerInfo(Map<String, Object> params) throws Exception;

	EgovMap checkNricExist(Map<String, Object> params) throws Exception;

	void updateNric(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap selectInstallInfo(Map<String, Object> params) throws Exception;

	EgovMap selectInstallAddrInfo(Map<String, Object> params) throws Exception;

	EgovMap selectInstallCntcInfo(Map<String, Object> params) throws Exception;

	EgovMap selectInstRsltCount(Map<String, Object> params) throws Exception;

	EgovMap selectGSTZRLocationCount(Map<String, Object> params) throws Exception;

	EgovMap selectGSTZRLocationByAddrIdCount(Map<String, Object> params) throws Exception;

	void updateInstallInfo(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap selectRentPaySetInfo(Map<String, Object> params) throws Exception;

	void updatePaymentChannel(Map<String, Object> params, SessionVO sessionVO) throws Exception;

	void saveDocSubmission(OrderVO orderVO, SessionVO sessionVO) throws Exception;

	List<EgovMap> selectReferralList(Map<String, Object> params);

	List<EgovMap> selectStateCodeList(Map<String, Object> params);

	void saveReferral(OrderModifyVO orderModifyVO, SessionVO sessionVO) throws Exception;

	void updatePromoPriceInfo(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) throws Exception;

	void updateGSTEURCertificate(GSTEURCertificateVO gSTEURCertificateVO, SessionVO sessionVO);

	void updateOrderMailingAddress2(Map<String, Object> params, SessionVO sessionVO) throws ParseException;

	EgovMap getInstallDetail(Map<String, Object> params);

	List<EgovMap> selectEditTypeList(Map<String, Object> params);

}
