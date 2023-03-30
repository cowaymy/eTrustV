package com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.api.mobile.payment.mobileLumpSumPayment.MobileLumpSumPaymentOrderDetailsForm;
import com.coway.trust.biz.payment.mobileLumpSumPaymentKeyIn.service.MobileLumpSumPaymentKeyInService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("mobileLumpSumPaymentKeyInService")
public class MobileLumpSumPaymentKeyInServiceImpl extends EgovAbstractServiceImpl implements MobileLumpSumPaymentKeyInService {
	  private static final Logger LOGGER = LoggerFactory.getLogger(MobileLumpSumPaymentKeyInServiceImpl.class);

	  @Autowired
	  private MessageSourceAccessor messageAccessor;
	  @Resource(name = "mobileLumpSumPaymentKeyInMapper")
	  private MobileLumpSumPaymentKeyInMapper mobileLumpSumPaymentKeyInMapper;

	  @Override
	  public List<EgovMap> customerInfoSearch(Map<String,Object> params){
		  String custCiType = params.get("custCiType").toString();

		  //Invoice Number Type Searching
		  if(custCiType.equals("1")){
			  EgovMap billingInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerBillingInfoByInvoiceNo(params);

			  params.put("nric", billingInfoSearchResult.get("nric").toString());
			  params.put("accBillCrtDt", billingInfoSearchResult.get("accBillCrtDt").toString());
			  params.put("accBillGrpId", billingInfoSearchResult.get("accBillGrpId").toString());
		  }

		  //Cust search by NRIC/Company IC
		  if(custCiType.equals("2")){
			  params.put("nric", params.get("custCi").toString());
		  }

		  List<EgovMap> customerInfoSearchResult = null;
		  if(params.get("nric") != null && !params.get("nric").toString().isEmpty()){
			  customerInfoSearchResult = mobileLumpSumPaymentKeyInMapper.getCustomerInfo(params);
		  }

		  return customerInfoSearchResult;
	  }

	  @Override
	  public List<EgovMap> getCustomerOutstandingDistinctOrder(Map<String,Object> params){
		  List<EgovMap> customerOutstandingOrder =  mobileLumpSumPaymentKeyInMapper.getCustomerOutstandingOrder(params);

		  List<EgovMap> customerOutstandingDistinctOrder = new ArrayList<>();
		  if(customerOutstandingOrder.size() > 0){
			  List<EgovMap> orderNoDistinct = new ArrayList<EgovMap>();
			  orderNoDistinct = customerOutstandingOrder.stream().filter(distinctByKey(p -> p.get("ordNo"))).collect(Collectors.toList());

			  for(EgovMap item : orderNoDistinct){
				  EgovMap newItem = new EgovMap();
				  newItem.put("ordNo", item.get("ordNo"));
				  newItem.put("ordTypeId", item.get("ordTypeId"));
				  newItem.put("ordTypeName", item.get("ordTypeName"));
				  customerOutstandingDistinctOrder.add(newItem);
			  }
		  }
		  return customerOutstandingDistinctOrder;
	  }

	  @Override
	  public List<EgovMap> getCustomerOutstandingOrderDetailList(Map<String,Object> params){
		  List<EgovMap> customerOutstandingOrders =  mobileLumpSumPaymentKeyInMapper.getCustomerOutstandingOrder(params);
		  return customerOutstandingOrders;
	  }

	  @Override
	  public Map<String, Object> submissionSave(Map<String,Object> params){
		  Map<String, Object> result = new HashMap<>();
		  int nextGroupID = mobileLumpSumPaymentKeyInMapper.selectNextMobPayGroupId();
		  EgovMap user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
		  params.put("userId", user.get("userId"));
		  params.put("mobilePayGrpNo", nextGroupID);
		  LOGGER.debug("Mobile LS : " + params);
		  mobileLumpSumPaymentKeyInMapper.insertPaymentMasterInfo(params);

		  List<Map<String,Object>> orderDetails = (List<Map<String, Object>>) params.get("orderDetailList");
		  if(orderDetails.size() > 0){
			  for(int i=0; i< orderDetails.size(); i++){
				  orderDetails.get(i).put("mobilePayGrpNo", nextGroupID);
				  mobileLumpSumPaymentKeyInMapper.insertPaymentDetailInfo(orderDetails.get(i));
			  }
		  }
		  return result;
	  }

	  @Override
	  public List<EgovMap> getLumpSumEnrollmentList(Map<String,Object> params){
		  List<EgovMap> resultList =  mobileLumpSumPaymentKeyInMapper.getLumpSumEnrollmentList(params);
		  return resultList;
	  }

	  @Override
	  public List<EgovMap> selectCashMatchingPayGroupList(Map<String,Object> params){
		  List<EgovMap> resultList =  mobileLumpSumPaymentKeyInMapper.selectCashMatchingPayGroupList(params);
		  return resultList;
	  }

	  @Override
	  public int mobileUpdateCashMatchingData(Map<String,Object> params){
		  EgovMap user = mobileLumpSumPaymentKeyInMapper.selectUser(params);
		  params.put("userId", user.get("userId"));
		  mobileLumpSumPaymentKeyInMapper.mobileUpdateCashMatchingData(params);
		  return 1;
	  }

	  private <T> Predicate<T> distinctByKey(Function<? super T, Object> keyExtractor)
	  {
	      Map<Object, Boolean> map = new ConcurrentHashMap<>();
	      return t -> map.putIfAbsent(keyExtractor.apply(t), Boolean.TRUE) == null;
	  }
}
