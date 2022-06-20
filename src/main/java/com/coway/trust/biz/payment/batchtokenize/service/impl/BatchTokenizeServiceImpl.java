package com.coway.trust.biz.payment.batchtokenize.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.batchtokenize.service.impl.BatchTokenizeMapper;
import com.coway.trust.biz.payment.batchtokenize.service.BatchTokenizeService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("batchTokenizeService")
public class BatchTokenizeServiceImpl extends EgovAbstractServiceImpl implements BatchTokenizeService {
	  @Resource(name = "BatchTokenizeMapper")
	  private BatchTokenizeMapper batchTokenizeMapper;



	  public List<EgovMap> verifyRecord(Map<String, Object> params) {
		  System.out.println("svc impl VerifyRecord");
		  int result = 0;
		  batchTokenizeMapper.delSAL0323T();
		  System.out.println(params);
		  result = batchTokenizeMapper.insertSAL0323T(params);
		  if(result != 0){
			  return batchTokenizeMapper.displayRecord();
		  }
		return null;
	}


	  public EgovMap processBatchTokenizeRecord() {
		  System.out.println("save Record");

		  EgovMap param = batchTokenizeMapper.selectBatchID();
		  //param.put("batchID",Integer.toString(BatchID));
		  System.out.println(param);
		  batchTokenizeMapper.displayRecord();
		  batchTokenizeMapper.insertSAL0319M(param);
		  batchTokenizeMapper.insertSAL0320D(param);


		  return param;
	}


	@Override
	public List<EgovMap> getCardDetails(EgovMap BatchID) {
		return batchTokenizeMapper.selectdataForCSV(BatchID);
	}

	public List<EgovMap> selectBatchTokenizeRecord(Map<String, Object> params){
		System.out.println(params);
		return batchTokenizeMapper.selectBatchTokenizeRecord(params);
	}


	@Override
	public EgovMap batchTokenizeDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return batchTokenizeMapper.batchTokenizeDetail(params);
	}


	@Override
	public List<EgovMap> batchTokenizeViewItmJsonList(Map<String, Object> params) {
		System.out.println(params);
		return batchTokenizeMapper.batchTokenizeViewItmJsonList(params);
	}



}
