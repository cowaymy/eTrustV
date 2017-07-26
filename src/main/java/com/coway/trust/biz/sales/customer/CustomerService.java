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
	EgovMap selectCustomerDetailAddr(Map<String, Object> params) throws Exception;
	
	
	/**
	 * 상세화면 조회. detail contact view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerDetailContact(Map<String, Object> params) throws Exception;
	
	
	/**
	 * 상세화면 조회. detail bank view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerDetailBank(Map<String, Object>  params)throws Exception;
	
	
	/**
	 * 상세화면 조회. detail bank view
	 * @param params 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	EgovMap selectCustomerDetailCreditCard(Map<String, Object> params) throws Exception;
}
