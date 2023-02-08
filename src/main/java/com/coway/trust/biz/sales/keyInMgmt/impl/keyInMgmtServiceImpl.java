package com.coway.trust.biz.sales.keyInMgmt.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.keyInMgmt.keyInMgmtService;
import com.coway.trust.util.CommonUtils;
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
		public int saveKeyInId(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId) {
			int saveCnt = 0;
			LOGGER.debug("udtList: {}" + udtList);

			// insert
			for (Object obj : addList) {
				((Map<String, Object>) obj).put("creator", userId);
				((Map<String, Object>) obj).put("updator", userId);

				saveCnt++;

				keyInMgmtMapper.insertKeyInId((Map<String, Object>) obj);
			}

			// update
			for (Object obj : udtList) {
				((Map<String, Object>) obj).put("creator", userId);
				((Map<String, Object>) obj).put("updator", userId);

				saveCnt++;

				keyInMgmtMapper.updateKeyInId((Map<String, Object>) obj);
			}

			// delete
			for (Object obj : delList) {
				((Map<String, Object>) obj).put("creator", userId);
				((Map<String, Object>) obj).put("updator", userId);

				saveCnt++;

				keyInMgmtMapper.deleteKeyInId((Map<String, Object>) obj);
			}

			return saveCnt;
		}

	@Override
	public List<EgovMap> selectKeyinMgmtList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;
	}
}
