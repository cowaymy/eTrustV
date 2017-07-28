package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CustomerService {

	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	List<EgovMap> selectCustomerList(Map<String, Object> params);
	

	/**
	 * 상세화면 조회. basic info
	 * 
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap selectCustomerViewBasicInfo(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. main address 
	 * @param params
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap selectCustomerViewMainAddress(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. main contact
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	EgovMap selectCustomerViewMainContact(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. customer address list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * 상세화면 조회. customer Contact list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. customer Bank list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. customer Card list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. own order list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * 상세화면 조회. third party list
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * 상세화면 조회. detail address view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.24
	 */
	EgovMap selectCustomerAddrDetailViewPop(Map<String, Object> params) throws Exception;
	
	
	/**
	 * get Customer Id Seq 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	int getCustIdSeq();
	
	
	/**
	 * get Customer Address Seq 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	int getCustAddrIdSeq();
	
	
	/**
	 * get Customer Contact Seq 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	int getCustCntcIdSeq();
	
	
	/**
	 * get Customer Care Contact Id Seq 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	int getCustCareCntIdSeq();
	
	
	/**
	 * insert Customer Basic Info 
	 * @param params
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	void insertCustomerInfo(Map<String, Object> params);
	
	
	/**
	 * insert install address  
	 * @param params
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	void insertAddressInfo(Map<String, Object> params);
	
	
	/**
	 * insert additional service contact
	 * @param params
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	void insertContactInfo(Map<String, Object> params);
	
	
	/**
	 * insert additional service contact (care contact)
	 * @param params
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	void insertCareContactInfo(Map<String, Object> params);
	
	
	
	
	/**
	 * 상세화면 조회. detail contact view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerContactDetailViewPop(Map<String, Object> params) throws Exception;
	
	
	/**
	 * 상세화면 조회. detail bank view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerBankDetailViewPop(Map<String, Object>  params)throws Exception;
	
	
	/**
	 * 상세화면 조회. detail credit card view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerCreditCardDetailViewPop(Map<String, Object> params) throws Exception;
}
