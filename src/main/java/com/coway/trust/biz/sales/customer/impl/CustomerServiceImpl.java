package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerService")
public class CustomerServiceImpl extends EgovAbstractServiceImpl implements CustomerService {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "customerMapper")
	private CustomerMapper customerMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param CustomerVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> selectCustomerList(Map<String, Object> params) {
		
		return customerMapper.selectCustomerList(params);
	}

	
	/**
	 * 상세화면 조회한다.(Basic Info)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap selectCustomerViewBasicInfo(Map<String, Object> params) throws Exception{
		
		return customerMapper.selectCustomerViewBasicInfo(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Main Address)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap selectCustomerViewMainAddress(Map<String, Object> params) throws Exception{
		
		return customerMapper.selectCustomerViewMainAddress(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Main Contact)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public EgovMap selectCustomerViewMainContact(Map<String, Object> params) throws Exception{
		
		return customerMapper.selectCustomerViewMainContact(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Address List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.20
	 */
	@Override
	public List<EgovMap> selectCustomerAddressJsonList(Map<String, Object> params) throws Exception{
		
		return customerMapper.selectCustomerAddressJsonList(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Contact List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustomerContactJsonList(Map<String, Object> params)throws Exception{
		
		return customerMapper.selectCustomerContactJsonList(params);
	}

	
	/**
	 * 상세화면 조회한다. (Bank List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustomerBankAccJsonList(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerBankAccJsonList(params);
	}

	
	/**
	 * 상세화면 조회한다. (Card List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustomerCreditCardJsonList(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerCreditCardJsonList(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Own Order List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustomerOwnOrderJsonList(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerOwnOrderJsonList(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Third Party Order List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustomerThirdPartyJsonList(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerThirdPartyJsonList(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Address View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.24
	 */
	@Override
	public EgovMap selectCustomerDetailAddr(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerDetailAddr(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Contact View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerDetailContact(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerDetailContact(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Bank View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerDetailBank(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerDetailBank(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Card View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerDetailCreditCard(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerDetailCreditCard(params);
	}
	
}
