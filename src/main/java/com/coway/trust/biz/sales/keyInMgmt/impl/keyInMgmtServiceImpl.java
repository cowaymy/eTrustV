package com.coway.trust.biz.sales.keyInMgmt.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.keyInMgmt.keyInMgmtService;
import com.coway.trust.biz.sales.order.vo.KeyInMgmtRawVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;
import com.ibm.icu.util.StringTokenizer;

import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("keyInMgmtService")
public class keyInMgmtServiceImpl implements keyInMgmtService{
	private static final Logger LOGGER = LoggerFactory.getLogger(keyInMgmtServiceImpl.class);

	  @Resource(name = "keyInMgmtMapper")
	  private keyInMgmtMapper keyInMgmtMapper;

	  @Override
		public List<EgovMap> searchKeyinMgmtList(Map<String, Object> params) {

		  LOGGER.debug("param: {}" + params.toString());

		  String[] dateFromArr = CommonUtils.nvl(params.get("dateFrom").toString()).split("/");
		  String[] dateToArr = CommonUtils.nvl(params.get("dateTo").toString()).split("/");

		  for(int i = 0; i < dateFromArr.length  ; i++){
			  if(i == 0){
				  params.put("fromMonth", dateFromArr[i]);
				  params.put("toMonth", dateToArr[i]);
			  }else{
				  params.put("fromYear", dateFromArr[i]);
				  params.put("toYear", dateToArr[i]);
			  }
		  }

	      return keyInMgmtMapper.searchKeyinMgmtList(params);
		}

	  @SuppressWarnings("unchecked")
	  @Override
		public int saveKeyInId(List<Object> udtList, Integer userId) {
			int saveCnt = 0;
			LOGGER.debug("udtList: {}" + udtList);

			// update
			for (Object obj : udtList) {
				((Map<String, Object>) obj).put("creator", userId);
				((Map<String, Object>) obj).put("updator", userId);

				saveCnt++;

				keyInMgmtMapper.updateKeyInId((Map<String, Object>) obj);
			}

			return saveCnt;
		}

	@Override
	public List<EgovMap> selectKeyinMgmtList(Map<String, Object> params) {
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public EgovMap uploadExcel(Map<String, Object> params, SessionVO sessionVO) {
		EgovMap rtnMap = new EgovMap();
		int rtnCnt = 0;

		List<KeyInMgmtRawVO> vos = (ArrayList<KeyInMgmtRawVO>) params.get("voList");

		EgovMap requestNo = getDocNo("193");
		String nextDocNo = getNextDocNo("KM", CommonUtils.nvl(requestNo.get("docNo")));
		requestNo.put("nextDocNo", nextDocNo);
		keyInMgmtMapper.updateDocNo((Map<String, Object>)requestNo);

		List<Map<String, Object>> list = vos.stream().map(r -> {Map<String, Object> map = BeanConverter.toMap(r);

			String keyInStartDt = r.getKeyInStartDt().trim();
			String keyInEndDt = r.getKeyInEndDt().trim();
			map.put("keyInStartDt",keyInStartDt);
			map.put("keyInEndDt", keyInEndDt);
			map.put("reqstNo", requestNo.get("docNo"));
			map.put("creator", sessionVO.getUserId());
			return map;
		}).collect(Collectors.toList());

		int size = 1000;
		int page = list.size() / size;
		int start;
		int end;

		Map<String, Object> keyinMgmtList = new HashMap<String, Object>();

		for (int i = 0; i <= page; i++) {
			start = i * size;
			end = size;

			if(i == page) {
				end = list.size();
			}
			keyinMgmtList.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

			LOGGER.debug("keyinMgmtList/////" + keyinMgmtList);
			rtnCnt = keyInMgmtMapper.uploadKeyInMgmt(keyinMgmtList);
			LOGGER.debug("keyinMgmtList/////" + rtnCnt);
			if(rtnCnt <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
			}
		}

		rtnMap.put("isErr", false);
		rtnMap.put("errMsg", "upload success");

		return rtnMap;
	}

	@Override
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = keyInMgmtMapper.selectDocNo(docNoId);
		LOGGER.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			LOGGER.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	@Override
	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		LOGGER.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}
}
