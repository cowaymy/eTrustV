package com.coway.trust.biz.payment.eGhlPaymentCollection.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.payment.eGhlPaymentCollection.service.EGhlPaymentCollectionService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("eGhlPaymentCollectionService")
public class EGhlPaymentCollectionServiceImpl extends EgovAbstractServiceImpl implements EGhlPaymentCollectionService {
	  @Autowired
	  private MessageSourceAccessor messageAccessor;

	  @Resource(name = "eGhlPaymentCollectionMapper")
	  private EGhlPaymentCollectionMapper eGhlPaymentCollectionMapper;

	  @Resource(name = "commonMapper")
	  private CommonMapper commonMapper;

	  private static final Logger LOGGER = LoggerFactory.getLogger(EGhlPaymentCollectionServiceImpl.class);

	  @Override
	  public List<EgovMap> orderNumberBillMobileSearch(Map<String,Object> params){
		  return eGhlPaymentCollectionMapper.orderNumberBillMobileSearch(params);
	  }

	  @Override
	  public String paymentCollectionRunningNumberGet(){
		    String pcNo = commonMapper.selectDocNo("189");

		    return pcNo;
	  }

	  @Override
	  public List<EgovMap> paymentCollectionMobileHistoryGet(Map<String,Object> params){
		  return eGhlPaymentCollectionMapper.paymentCollectionMobileHistoryGet(params);
	  }

	  @Override
	  public int paymentCollectionMobileCreation(Map<String,Object> params, List<Map<String,Object>> paramDetails) {
		  EgovMap user = eGhlPaymentCollectionMapper.getUserByUserName(params);

		  if(user != null){
			  params.put("userId", user.get("userId"));
		  }
		  int masterId = eGhlPaymentCollectionMapper.selectNextPay0336mId();
		  params.put("id", masterId);
		  //master table data add
		  int masterResult =  eGhlPaymentCollectionMapper.insertPaymentCollectionMaster(params);

		  if(masterResult > 0){
			  //detail add
			  for(int i=0; i < paramDetails.size(); i++){
				  Map<String,Object> detail = paramDetails.get(i);
				  detail.put("userId", user.get("userId"));
				  detail.put("id", params.get("id"));

				  boolean productBillChecked = Boolean.parseBoolean(detail.get("productBillChecked").toString());
				  boolean svmBillChecked = Boolean.parseBoolean(detail.get("svmBillChecked").toString());

				  Map<String,Object> newDetailParam = new HashMap();
				  newDetailParam.put("id", Integer.parseInt(detail.get("id").toString()));
				  newDetailParam.put("salesOrdId", Integer.parseInt(detail.get("salesOrdId").toString()));
				  newDetailParam.put("salesOrdNo", detail.get("salesOrdNo").toString());
				  newDetailParam.put("userId", detail.get("userId"));
				  if(productBillChecked){
					  newDetailParam.put("productTypeCode", detail.get("productTypeCode").toString());
					  newDetailParam.put("productTypeName", detail.get("productTypeName").toString());
					  newDetailParam.put("amount", Double.parseDouble(detail.get("productOutstandingAmount").toString()));

					  eGhlPaymentCollectionMapper.insertPaymentCollectionDetail(newDetailParam);
				  }

				  if(svmBillChecked){
					  String productTypeName = detail.get("membership").toString();
					  String productTypeCode = "SVM";
					  if(productTypeName.trim().toUpperCase().equals("OUTRIGHT MEMBERSHIP")){
						  productTypeCode = "SVMOUT";
					  }
					  else if(productTypeName.trim().toUpperCase().equals("RENTAL MEMBERSHIP")){
						  productTypeCode = "SVMREN";
					  }
					  newDetailParam.put("productTypeCode", productTypeCode);
					  newDetailParam.put("productTypeName", detail.get("membership").toString());
					  newDetailParam.put("amount", Double.parseDouble(detail.get("membershipOutstandingAmount").toString()));

					  eGhlPaymentCollectionMapper.insertPaymentCollectionDetail(newDetailParam);
				  }
			  }
		  }
		  else{
			  return 0;
		  }
		  return 1;
	  }

	  @Override
	  public List<EgovMap> selectPaymentCollectionList(Map<String,Object> params){
		  return eGhlPaymentCollectionMapper.selectPaymentCollectionList(params);
	  }
}
