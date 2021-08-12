package com.coway.trust.biz.sales.trBook.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.trBook.SalesTrBookRecvService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("salesTrBookRecvService")
public class SalesTrBookRecvServiceImpl  extends EgovAbstractServiceImpl implements SalesTrBookRecvService{

	private static final Logger logger = LoggerFactory.getLogger(SalesTrBookRecvServiceImpl.class);
	
	@Resource(name = "salesTrBookRecvMapper")
	private SalesTrBookRecvMapper salesTrBookRecvMapper;
	
	@Resource(name = "salesTrBookMapper")
	private SalesTrBookMapper salesTrBookMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public List<EgovMap> selectTrBookRecvList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return salesTrBookRecvMapper.selectTrBookRecvList(params);
	}

	@Override
	public EgovMap selectTransitInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return salesTrBookRecvMapper.selectTransitInfo(params);
	}

	@Override
	public List<EgovMap> selectTransitList(Map<String, Object> params) {
		return salesTrBookRecvMapper.selectTransitList(params);
	}

	@Override
	public void updateTransit(Map<String, Object> params) {
		
		List<Object> list = (List<Object>) params.get("gridData");
		
		logger.debug("list ========>> " + list);
		logger.debug("params ========>> " + params);
		
		String targetLocation = "";
		if("4".equals(params.get("status"))){
			targetLocation = params.get("trnsitTo").toString();
		}else{
			targetLocation = params.get("trnsitFrom").toString();
		}

		for (Object obj : list) 
		{
			Map<String, Object> param = new HashMap();
			
			param.put("docNo", params.get("docNo"));
			param.put("userId", params.get("userId"));
			param.put("trBookId",  ((Map<String, Object>) obj).get("trBookId"));
			param.put("trTrnsitDetId",  ((Map<String, Object>) obj).get("trTrnsitDetId"));
			param.put("status",  params.get("status"));
			
			param.put("trTypeId", 754);
			param.put("trLocCode", targetLocation);
			param.put("trRcordQyt", 1);
			salesTrBookMapper.insertTrRecord(param);

			param.put("trLocCode", params.get("trnsitCurier"));
			param.put("trRcordQyt", -1);
			salesTrBookMapper.insertTrRecord(param);
			
			param.put("detail", "detail");
			
			if(salesTrBookRecvMapper.selectTransitDetailInfo(param) != null){
				salesTrBookRecvMapper.updateTransitDetail(param);
			}
		}
		
		if(salesTrBookRecvMapper.selectTransitDetailInfo(params) == null){
			if(!"36".equals(params.get("trnsitStusId").toString())){
				
				if(salesTrBookRecvMapper.selectTransitM(params) != null){

					 params.put("trTrnsitStusId", 36);
					 salesTrBookRecvMapper.updateTransitM(params);
				}
			}
			
		}else{
			if("1".equals(params.get("trnsitStusId").toString())){
				if(salesTrBookRecvMapper.selectTransitM(params) != null){

					 params.put("trTrnsitStusId", 44);
					 salesTrBookRecvMapper.updateTransitM(params);
				}
			}
		}
	}

	@Override
	public List<EgovMap> getbrnchList() {
		
		return salesTrBookRecvMapper.getbrnchList();
	}

	@Override
	public List<EgovMap> getTransitListByTransitNo(Map<String, Object> params) {
		
		return salesTrBookRecvMapper.getTransitListByTransitNo(params);
	}

	@Override
	public List<EgovMap> trBookSummaryListing(Map<String, Object> params) {
		
		return salesTrBookRecvMapper.trBookSummaryListing(params);
	}
	
	
}
