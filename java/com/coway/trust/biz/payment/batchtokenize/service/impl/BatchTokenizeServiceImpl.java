package com.coway.trust.biz.payment.batchtokenize.service.impl;


import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.batchtokenize.service.impl.BatchTokenizeMapper;
import com.coway.trust.util.BeanConverter;
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
		  //System.out.println(params);
		  List<Map> vos = (List<Map>) params.get("all");

		  List<Map> conversionList = vos.stream().map(r -> {
        Map<String, Object> map = BeanConverter.toMap(r);

        map.put("0",r.get("0"));
        map.put("1",r.get("1"));
        map.put("2",r.get("2"));
        map.put("3",r.get("3"));
        map.put("4",r.get("4"));
        map.put("5",r.get("5"));
        map.put("6",r.get("6"));
        map.put("7",r.get("7"));
        map.put("8",r.get("8"));
        map.put("9",r.get("9"));
        map.put("10",r.get("10"));
        map.put("11",r.get("11"));


        return map;
    }).collect(Collectors.toList());

		  int size = 1000;
	    int page = conversionList.size() / size;
	    int start;
	    int end;

	    Map<String, Object> bulkMap = new HashMap<>();
	    for (int i = 0; i <= page; i++) {
	      start = i * size;
	      end = size;
	      if (i == page) {
	        end = conversionList.size();
	      }
	      bulkMap.put("list", conversionList.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
	      result = batchTokenizeMapper.insertSAL0323T(bulkMap);
	    }

		  if(result != 0){
			  return batchTokenizeMapper.displayRecord();
		  }
		return null;
	}


	  public EgovMap processBatchTokenizeRecord(int Userid) {
		  System.out.println("save Record");

		  EgovMap param = batchTokenizeMapper.selectBatchID();
		  param.put("user_id",Userid);
		  //param.put("batchID",Integer.toString(BatchID));
		  System.out.println(param);
		  batchTokenizeMapper.displayRecord();
		  batchTokenizeMapper.insertSAL0319M(param);
		  batchTokenizeMapper.insertSAL0320D(param);


		  return param;
	}


	@Override
	public List<EgovMap> getCardDetails(EgovMap BatchID) {
		List<EgovMap> CSVData = batchTokenizeMapper.selectdataForCSV(BatchID);
		batchTokenizeMapper.maskCRCNO(BatchID);
		return  CSVData;
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
