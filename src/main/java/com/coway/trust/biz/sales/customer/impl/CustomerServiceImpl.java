package com.coway.trust.biz.sales.customer.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.sales.customer.CustomerBVO;
import com.coway.trust.biz.sales.customer.CustomerCVO;
import com.coway.trust.biz.sales.customer.CustomerService;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerService")
public class CustomerServiceImpl extends EgovAbstractServiceImpl implements CustomerService {

	private static final Logger logger = LoggerFactory.getLogger(CustomerServiceImpl.class);
	
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
	@Override
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
	 * 상세화면 조회한다. (Contact List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectCustCareContactList(Map<String, Object> params)throws Exception{
		
		return customerMapper.selectCustCareContactList(params);
	}

	
	/**
	 * 상세화면 조회한다. (Contact List)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.07.21
	 */
	@Override
	public List<EgovMap> selectBillingGroupByKeywordCustIDList(Map<String, Object> params)throws Exception{
		
		List<EgovMap> result = customerMapper.selectBillingGroupByKeywordCustIDList(params);
		
		List<EgovMap> resultNew = new ArrayList<>();
		
		for(EgovMap eMap : result) {
			
			String billAddrFull = "";
			String billType = "";

			if(CommonUtils.isNotEmpty(eMap.get("add1")))      billAddrFull += eMap.get("add1") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("add2")))      billAddrFull += eMap.get("add2") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("add3")))      billAddrFull += eMap.get("add3") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("postCode")))  billAddrFull += eMap.get("postCode") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("areaName")))  billAddrFull += eMap.get("areaName") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("stateName"))) billAddrFull += eMap.get("stateName") + " ";
			if(CommonUtils.isNotEmpty(eMap.get("cntyName")))  billAddrFull += eMap.get("cntyName") + " ";
			
			if(((BigDecimal)eMap.get("custBillIsPost")).compareTo(BigDecimal.ONE) == 0) {
				billType += "Post";
			}
			if(((BigDecimal)eMap.get("custBillIsSms")).compareTo(BigDecimal.ONE) == 0) {
				billType += CommonUtils.isNotEmpty(billType) ? ",SMS" : "SMS"; 
			}
			if(((BigDecimal)eMap.get("custBillIsEstm")).compareTo(BigDecimal.ONE) == 0) {
				billType += CommonUtils.isNotEmpty(billType) ? ",EStatement" : "EStatement"; 
			}
			
			eMap.put("billAddrFull", billAddrFull);
			eMap.put("billType", billType);
			
			resultNew.add(eMap);
		}
		
		
		return resultNew;
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
	
	
	/**
	 * NRIC / Company No 중복체크 
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 
	 */
	public int nricDupChk(Map<String, Object> params){
		int nricDupChk = customerMapper.nricDupChk(params);
		return nricDupChk;
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
	 * Main Address 업데이트 (Set Main)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.01
	 */
	@Override
	@Transactional
	public void updateCustomerAddressSetMain(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerAddressSetActive(params);
		customerMapper.updateCustomerAddressSetMain(params);
	}


	/**
	 * Main Contact 업데이트 (Set Main)
	 * @param 
	 * @return 
	 * @exception Exception
	 * @author 이석희 2017.08.03
	 */
	@Override
	@Transactional
	public void updateCustomerContactSetMain(Map<String, Object> params) throws Exception {
		
		customerMapper.updateCustomerContactSetActive(params);
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
	public List<EgovMap> selectAccBank(Map<String, Object> params)  {
		
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
	
	
	/**
	 *  Credit Card Issue Bank 
	 */
	@Override
	public List<EgovMap> selectIssueBank(Map<String, Object> params) {
		return customerMapper.selectIssueBank(params);
	}
	
	
	@Override
	public int getCustCrcIdSeq() {
		
		int getCustCrcIdSeq = customerMapper.getCustCrcIdSeq();
		
		return getCustCrcIdSeq;
	}
	
	
	@Override
	public void insertCreditCardInfo(List<CustomerCVO> customerCardVOList) {
		
		for(CustomerCVO customerCVO : customerCardVOList) {
			logger.debug("##### Impl >> getCreditCardNo :"+customerCVO.getCreditCardNo());
			customerMapper.insertCreditCardInfo(customerCVO);
		}
		
	}
	
	
	@Override
	public int getCustIdMaxSeq() {
		
		int getCustIdMaxSeq = customerMapper.getCustIdMaxSeq();
		
		return getCustIdMaxSeq;
	}
	
	
	
	@Override
	public int getCustAccIdSeq() {
		
		int getCustAccIdSeq = customerMapper.getCustAccIdSeq();
		
		return getCustAccIdSeq;
	}
	
	
	@Override
	public void insertBankAccountInfo(List<CustomerBVO> customerBankVOList) {
		
		for(CustomerBVO customerBVO : customerBankVOList) {
			
			customerMapper.insertBankAccountInfo(customerBVO);
		}
		
	}
	
	
	/**
	 * Customer Magic Address 
	 * 
	 * @param 
	 * @return Customer Magic Address 
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> searchMagicAddressPop(Map<String, Object> params) {
		
		return customerMapper.searchMagicAddressPop(params);
	}


	/**
	 * Customer Add New Address  (Af)  
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertCustomerAddressInfoAf(Map<String, Object> params) throws Exception {
		
		customerMapper.insertCustomerAddressInfoAf(params);
	}
	
	
	/**
	 * Customer Add New Contact (Af)  
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertCustomerContactAddAf(Map<String, Object> params) throws Exception {
		customerMapper.insertCustomerContactAddAf(params);
		
	}


	/**
	 * Customer Add New Bank Account (Af)  
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertCustomerBankAddAf(Map<String, Object> params) throws Exception {
		
		customerMapper.insertCustomerBankAddAf(params);
		
	}


	/**
	 * Customer Add New Card Account (Af)  
	 * 
	 * @param 
	 * @return void
	 * @exception Exception
	 */
	@Override
	public void insertCustomerCardAddAf(Map<String, Object> params) throws Exception {
		
		customerMapper.insertCustomerCardAddAf(params);
	}

}
