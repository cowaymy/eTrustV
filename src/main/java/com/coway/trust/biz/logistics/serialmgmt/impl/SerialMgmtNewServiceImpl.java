/**
 * @author .
 **/
package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("serialMgmtNewService")
public class SerialMgmtNewServiceImpl implements SerialMgmtNewService{

	private static final Logger logger = LoggerFactory.getLogger(SerialMgmtNewServiceImpl.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

	@Resource(name = "serialMgmtNewMapper")
	private SerialMgmtNewMapper serialMgmtNewMapper;

	@Override
	public List<Object> saveHPSerialCheck(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{

		List<Object> mainList = (List<Object>)params.get("barList");

		String crDate = "";
		String month = "";
		String sDate = "";

		String vIoType = "";
		String vToLocId = "";
		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("boxno", mainMap.get("barcode"));

			// 날짜형식이 맞는지 체크.
			crDate = (String)mainMap.get("crDate");
			if(StringUtils.isBlank(crDate) || crDate.length() != 5){
				mainMap.put("stockName", "Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			month = crDate.substring(2, 3);

			switch(month){
    			case "A":
    				month = "10";
    				break;
    			case "B":
    				month = "11";
    				break;
    			case "C":
    				month = "12";
    				break;
    			default:
    				month = "0"+month;
    			break;
			}
			sDate = crDate.substring(0, 2) + month + crDate.substring(3, 5);
			if(!validationDate(sDate)){
				mainMap.put("stockName", "Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			EgovMap itemmap = serialMgmtNewMapper.selectItemSerch(mainMap);
			if(itemmap == null || itemmap.size() == 0){
				mainMap.put("stockName", "Serial No. (Invalid Item)");
				mainMap.put("status", 0);
				continue;
			}else{
				mainMap.put("stockId", itemmap.get("stkId"));
				mainMap.put("stockCode", itemmap.get("stkCode"));
				mainMap.put("stockName", itemmap.get("stkDesc"));
				mainMap.put("uom", itemmap.get("uom"));
			}

			// LOG0100M 체크
			if(serialMgmtNewMapper.selectHPSerialMgtCheck(mainMap) > 0){
				mainMap.put("stockName", "Serial No. (Duplicate)");
				mainMap.put("status", 0);
				continue;
			}

			// LOG0099D -- 스캔관리
			EgovMap scanInfo = serialMgmtNewMapper.selectHPScanInfoCheck(mainMap);
		    if(scanInfo != null){
		    	// 완료건.
		    	if("C".equals((String)scanInfo.get("scanStusCode"))){
		    		mainMap.put("stockName", "Serial No. (Use Complete)");
					mainMap.put("status", 0);
					continue;
		    	}

		    	//  중복 시리얼처리. 입고 -> 입고
		    	if("S".equals((String)scanInfo.get("scanStusCode"))){
		    		vIoType = (String)scanInfo.get("ioType");
		    		//vToLocId = (String)scanInfo.get("toLocId");
		    		if(  vIoType.equals( (String)mainMap.get("ioType"))
		    		  //&& vToLocId.equals( (String)mainMap.get("fromCdcCode"))
		    		  ){
		    			mainMap.put("stockName", "Serial No. (Duplicate)");
						mainMap.put("status", 0);
						continue;
		    		}
		    	}
		    }

		    mainMap.put("docNoItm", serialMgmtNewMapper.selectHPDeliveryGRInfo(mainMap));
		    if(StringUtils.isBlank((String)mainMap.get("docNoItm"))){
		    	mainMap.put("stockName", "Serial No. (Invalid stock)");
				mainMap.put("status", 0);
				continue;
		    }

		    mainMap.put("stkGrad", "A");

			// LOG0099D -- HP insert
		    serialMgmtNewMapper.insertSerialInfo(mainMap);

		    // LOG0100M
		    serialMgmtNewMapper.saveSerialMaster(mainMap);

		    // LOG0101H
		    serialMgmtNewMapper.insertSerialMasterHistory(mainMap);

		    mainMap.put("status", 1);		// success state
		    mainMap.put("boxQty", 0);
		    mainMap.put("eaQty",  1);
		    mainMap.put("totQty", 1);
		}

		return mainList;
	}

	@Override
	public void deleteHPSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		if(serialMgmtNewMapper.selectHPDelStsCheck(params) <= 0){
			throw new ApplicationException(AppConstants.FAIL,
					messageAccessor.getMessage(AppConstants.MSG_NOT_EXIST, new Object[] { "Serial No(String)" }));
		}

		// LOG0099D
		serialMgmtNewMapper.deleteSerialInfo(params);

		// LOG0100M -- State : N - update
		params.put("stusCode", "N");
		serialMgmtNewMapper.deleteSerialMaster(params);

		// LOG0101H -- LOG0100M --
		serialMgmtNewMapper.copySerialMasterHistory(params);
	}

	@Override
	public void allDeleteHPSerial(Map<String, ArrayList<Map<String, Object>>> params, SessionVO sessionVO) throws Exception{
		List<Map<String, Object>> mainList = params.get("dataList");
		for (Map<String, Object> map : mainList) {
			deleteHPSerial(map, sessionVO);
		}
	}

	private boolean validationDate(String checkDate){
		try{
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
			dateFormat.setLenient(false);
			dateFormat.parse(checkDate);
			return true;
		}catch (ParseException  e){
			return false;
		}
	}
}