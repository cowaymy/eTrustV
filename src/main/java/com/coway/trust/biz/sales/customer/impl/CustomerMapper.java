package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customerMapper")
public interface CustomerMapper {

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
	 * Customer View Basic Info mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerViewBasicInfo(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer View Main Address mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerViewMainAddress(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer View Main Contact mapper
	 * 
	 * @param params
	 * @return EgovMap
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerViewMainContact(Map<String, Object> params)throws Exception;
	
	
	/**
	 * Customer View Address List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * Customer View Contact List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params)throws Exception;
	
	
	/**
	 * Customer View Bank List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer View Card List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer Own Order List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer Third Party Order List mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer Address Detail View mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerDetailAddr(Map<String, Object> params) throws Exception;
	
	
	/**
	 * get customer Id 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int getCustIdSeq();
	
	
	/**
	 * get customer Address 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int getCustAddrIdSeq();
	
	
	/**
	 * get customer Contact
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int getCustCntcIdSeq();
	
	
	/**
	 * get customer Care Contact 
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int getCustCareCntIdSeq();
	
	
	/**
	 * insert customer Info Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int insertCustomerInfo(Map<String, Object> params);
	
	
	/**
	 * update customer Info Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int updateCustomerInfo(Map<String, Object> params);
	
	
	/**
	 * insert address Info Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int insertAddressInfo(Map<String, Object> params);
	
	
	/**
	 * insert contact Info Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int insertContactInfo(Map<String, Object> params);
	
	
	/**
	 * insert care contact Info Data
	 * 
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	int insertCareContactInfo(Map<String, Object> params);
	
	
	/**
	 * Customer Contact Detail View mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerDetailContact(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer Bank Detail View mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerDetailBank(Map<String, Object> params) throws Exception;
	
	
	/**
	 * Customer Card Detail View mapper
	 * 
	 * @param params
	 * @return List<EgovMap>
	 * @exception Exception
	 * @author 이석희
	 */
	EgovMap selectCustomerDetailCreditCard(Map<String, Object> params) throws Exception;
}
