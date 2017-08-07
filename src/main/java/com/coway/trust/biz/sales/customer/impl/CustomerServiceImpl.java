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
	public EgovMap selectCustomerAddrDetailViewPop(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerAddrDetailViewPop(params);
	}
	
	
	@Override
	public int getCustIdSeq() {
		
		int getCustId = customerMapper.getCustIdSeq();
		
		return getCustId;
	}
	
	
	@Override
	public int getCustAddrIdSeq() {
		
		int getCustAddrId = customerMapper.getCustAddrIdSeq();
		
		return getCustAddrId;
	}
	
	
	@Override
	public int getCustCntcIdSeq() {
		
		int getCustCntcId = customerMapper.getCustCntcIdSeq();
		
		return getCustCntcId;
	}
	
	
	@Override
	public int getCustCareCntIdSeq() {
		
		int getCustCareCntId = customerMapper.getCustCareCntIdSeq();
		
		return getCustCareCntId;
	}
	
	
	@Override
	public void insertCustomerInfo(Map<String, Object> params) {
		
		customerMapper.insertCustomerInfo(params);
	}
	
	
	@Override
	public void insertAddressInfo(Map<String, Object> params) {
		
		customerMapper.insertAddressInfo(params);
	}
	
	
	@Override
	public void insertContactInfo(Map<String, Object> params) {
		
		customerMapper.insertContactInfo(params);
	}
	
	
	@Override
	public void insertCareContactInfo(Map<String, Object> params) {
		
		customerMapper.insertCareContactInfo(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Contact View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerContactDetailViewPop(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerContactDetailViewPop(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Bank View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerBankDetailViewPop(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerBankDetailViewPop(params);
	}
	
	
	/**
	 * 상세화면 조회한다. (Detail Card View)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.25
	 */
	@Override
	public EgovMap selectCustomerCreditCardDetailViewPop(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCustomerCreditCardDetailViewPop(params);
	}

	
	/**
	 * 기본정보 업데이트 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.01
	 */
	@Override
	public void updateCustomerBasicInfoAf(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerBasicInfoAf(params);
	}

	
	/**
	 * Main Address 업데이트 (Set Active)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.01
	 */
	@Override
	public void updateCustomerAddressSetActive(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerAddressSetActive(params);
		
	}


	/**
	 * Main Address 업데이트 (Set Main)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.01
	 */
	@Override
	public void updateCustomerAddressSetMain(Map<String, Object> params) throws Exception {

		customerMapper.updateCustomerAddressSetMain(params);
	}


	/**
	 * Main Contact 업데이트 (Set Active)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void updateCustomerContactSetActive(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerContactSetActive(params);
		
	}


	/**
	 * Main Contact 업데이트 (Set Main)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void updateCustomerContactSetMain(Map<String, Object> params) throws Exception {
		
		
		//set STUS_CODE_ID == 9 <MAIN>
		customerMapper.updateCustomerContactSetMain(params);
	}


	/**
	 * 연락처 업데이트
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void updateCustomerContactInfoAf(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerContactInfoAf(params);
		
	}

	
	/**
	 * Bank ComboBox List (Issue Bank)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.04
	 */
	@Override
	public List<EgovMap> selectAccBank(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectAccBank(params);
	}


	/**
	 * Card ComboBox List (Issue Bank)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.04
	 */
	@Override
	public List<EgovMap> selectCrcBank(Map<String, Object> params) throws Exception {
		
		return customerMapper.selectCrcBank(params);
	}


	/**
	 * 은행 Account 업데이트
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void updateCustomerBankInfoAf(Map<String, Object> params) throws Exception {
		customerMapper.updateCustomerBankInfoAf(params);
		
	}


	/**
	 * 카드 Account 업데이트
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void updateCustomerCardInfoAf(Map<String, Object> params) throws Exception {
		customerMapper.updateCustomerCardInfoAf(params);
	}

	
	/**
	 * Address Delete
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void deleteCustomerAddress(Map<String, Object> params) throws Exception {
		customerMapper.deleteCustomerAddress(params);
	}

	
	/**
	 * Contact Delete
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	public void deleteCustomerContact(Map<String, Object> params) throws Exception {
		customerMapper.deleteCustomerContact(params);
	}


	/**
	 * Bank Delete
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.07
	 */
	@Override
	public void deleteCustomerBank(Map<String, Object> params) throws Exception {
		customerMapper.deleteCustomerBank(params);
		
	}


	/**
	 * Card Delete
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.07
	 */
	@Override
	public void deleteCustomerCard(Map<String, Object> params) throws Exception {
		customerMapper.deleteCustomerCard(params);
	}


	/**
	 * Address Update
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.07
	 */
	@Override
	public void updateCustomerAddressInfoAf(Map<String, Object> params) throws Exception {
		customerMapper.updateCustomerAddressInfoAf(params);
	}
}
