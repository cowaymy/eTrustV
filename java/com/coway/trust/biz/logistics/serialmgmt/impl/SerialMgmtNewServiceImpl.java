/**
 * @author .
 **/
package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
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
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.homecare.po.HcDeliveryGrService;
import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtNewService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("serialMgmtNewService")
public class SerialMgmtNewServiceImpl implements SerialMgmtNewService{

	private static final Logger logger = LoggerFactory.getLogger(SerialMgmtNewServiceImpl.class);

	@Autowired
	private MessageSourceAccessor messageAccessor;

    @Resource(name = "commonService")
    private CommonService commonService;

    @Resource(name = "hcDeliveryGrService")
    private HcDeliveryGrService hcDeliveryGrService;


	@Resource(name = "serialMgmtNewMapper")
	private SerialMgmtNewMapper serialMgmtNewMapper;

	@Override
	public List<Object> saveHPSerialCheck(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{

		List<Object> mainList = (List<Object>)params.get("barList");
		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
		boolean byPassCrDateCheck = false;

		logger.info("###params : " + params.toString());

		/*// Supplier code List.
		Map<String, Object> gMap = new HashMap<String, Object>();
		gMap.put("groupCode", "449");
		gMap.put("codeName", params.get("vendorId"));
		List<EgovMap> supplierList = commonService.selectCodeList(gMap);*/

		logger.info("#####Vendor: " + params.get("vendorId"));

		String supplierCode = "";
		String crDate = "";
		String month = "";
		String sDate = "";

		String vIoType = "";
		String vToLocId = "";
		Map<String, Object> mainMap = null;

		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ind", "SE_SCAN_BP");
		param.put("disb", 0);
		List<EgovMap> byPassItmList = serialMgmtNewMapper.selectScanByPassItm(param);


		for (Object obj : mainList) {

			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("boxno", mainMap.get("barcode"));

			// Supplier code List.
			Map<String, Object> gMap = new HashMap<String, Object>();
			gMap.put("groupCode", "449");
			gMap.put("codeName", mainMap.get("vendorId"));
			List<EgovMap> supplierList = commonService.selectCodeList(gMap);

			// check supplierCode.
			supplierCode = ((String)mainMap.get("barcode")).substring(0, 3);
			if(!validationSupplierCode(supplierList, supplierCode)){
				mainMap.put("stockName", "Supplier. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			// check dateFormat. (날짜형식이 맞는지 체크.)
			crDate = (String)mainMap.get("crDate");
			if(StringUtils.isBlank(crDate) || crDate.length() != 5){
				mainMap.put("stockName", "Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			EgovMap itemmap = serialMgmtNewMapper.selectItemSerch(mainMap);
			if(itemmap == null || itemmap.size() == 0){
				mainMap.put("stockName", "Serial No. (Invalid Item Code)");
				mainMap.put("status", 0);
				continue;
			}else{

				if (byPassItmList != null && byPassItmList.size() > 0) {
					for (EgovMap byPassItm: byPassItmList){
						logger.info("### byPassItm: " + byPassItm.toString());
						if ((byPassItm.get("code").toString()).equals((itemmap.get("stkCode").toString()))){
							byPassCrDateCheck = true;
							logger.info("### Bypass: " + byPassCrDateCheck);
							break;
						}
					}
				}
				mainMap.put("stockId", itemmap.get("stkId"));
				mainMap.put("stockCode", itemmap.get("stkCode"));
				mainMap.put("stockName", itemmap.get("stkDesc"));
				mainMap.put("uom", itemmap.get("uom"));
			}

			if (!byPassCrDateCheck){
    			month = crDate.substring(2, 3);

    			logger.info("crDate: " + crDate);
    			logger.info("month: " + month);

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
			}

			// serial use Y/N check.(1)
			if(!"Y".equals(itemmap.get("serialChk").toString())){
				mainMap.put("stockName", "Unused item Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			// serial use Y/N check.(2)
			itemmap.put("cdc", mainMap.get("toLocCode"));
			String serialChk = hcDeliveryGrService.selectLocationSerialChk(itemmap);
			if(StringUtils.isEmpty(serialChk) || !"Y".equals(serialChk) ){
				mainMap.put("stockName", "Unused Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
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
		    	// Check serial prefix conversion configuration setting - LOG0205M
		      mainMap.put("preConStockId", itemmap.get("stkId"));
		    	String serialPrefixChk = serialMgmtNewMapper.selectSerialPrefixConversion(mainMap);
		    	if(StringUtils.isEmpty(serialPrefixChk)){
		    	mainMap.put("stockName", "Serial No. (Invalid stock)");
				mainMap.put("status", 0);
				continue;
		    	}else{
		    	  // Check the original stock code - HMC0010D
		    	  String originalStockCode = serialMgmtNewMapper.selectHPDeliveryGRStockCode(mainMap);
		    	  mainMap.put("stockCode", originalStockCode);
		    		mainMap.put("docNoItm", serialPrefixChk);
		    	}
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

	// 1.Non Homecare serial save
	@Override
	public List<Object> saveLogisticBarcode(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> mainList = (List<Object>)params.get("barList");

		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
		boolean byPassCrDateCheck = false;

		String crDate = "";
		String month = "";
		String sDate = "";

		String vIoType = "";
		String vToLocId = "";

		// Added for by pass crDate checking by specific stock code. By Hui Ding, 12-06-2020
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ind", "SE_SCAN_BP");
		param.put("disb", 0);
		List<EgovMap> byPassItmList = serialMgmtNewMapper.selectScanByPassItm(param);

		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("boxno", mainMap.get("barcode"));

			EgovMap itemmap = serialMgmtNewMapper.selectItemSerch(mainMap);
			if(itemmap == null || itemmap.size() == 0){
				mainMap.put("stockName", "Serial No. (Invalid Item)");
				mainMap.put("status", 0);
				continue;
			}else{

				if (byPassItmList != null && byPassItmList.size() > 0) {
					for (EgovMap byPassItm: byPassItmList){
						logger.info("### byPassItm: " + byPassItm.toString());
						if ((byPassItm.get("code").toString()).equals((itemmap.get("stkCode").toString()))){
							byPassCrDateCheck = true;
							logger.info("### Bypass: " + byPassCrDateCheck);
							break;
						}
					}
				}

				mainMap.put("stockId", itemmap.get("stkId"));
				mainMap.put("stockCode", itemmap.get("stkCode"));
				mainMap.put("stockName", itemmap.get("stkDesc"));
				mainMap.put("uom", itemmap.get("uom"));
			}

			// 날짜형식이 맞는지 체크.
			crDate = (String)mainMap.get("crDate");
			if(StringUtils.isBlank(crDate) || crDate.length() != 5){
				mainMap.put("stockName", "Serial No. (Invalid)");
				mainMap.put("status", 0);
				continue;
			}

			if (!byPassCrDateCheck){
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
			}

			serialMgmtNewMapper.callBarcodeScan(mainMap);

			//System.out.println("ERR CODE : " + (String)mainMap.get("errCode"));
			//System.out.println("ERR MSG : " + (String)mainMap.get("errMsg"));

			if("000".equals((String)mainMap.get("errCode"))){
				mainMap.put("scanNo",(String)mainMap.get("outScanNo"));

			}else if("-1".equals((String)mainMap.get("errCode"))){
				throw new ApplicationException(AppConstants.FAIL, (String)mainMap.get("errMsg"));
			}else{
				mainMap.put("stockName", (String)mainMap.get("errMsg"));
				mainMap.put("status", 0);
				continue;
			}

			mainMap.put("status", 1);		// success state
			mainMap.put("boxQty", 0);
			mainMap.put("eaQty",  1);
			mainMap.put("totQty", 1);
		}


		return mainList;
	}

	// 2.Non Homecare serial delete
	@Override
	public void deleteSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		serialMgmtNewMapper.callDeleteBarcodeScan(params);

		if(!"000".equals((String)params.get("errCode"))){
			throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		}
	}

	// 3. Non Homecare Grid All Delete
	public void deleteGridSerial(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		List<Object> dataList = (List<Object>)params.get("dataList");
		Map<String, Object> delMap = null;
		for (Object obj : dataList) {
			delMap = (Map<String, Object>) obj;
			deleteSerial(delMap, sessionVO);
		}
	}


	// 4.Non Homecare serial save
	@Override
	public void saveSerialCode(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		serialMgmtNewMapper.callSaveBarcodeScan(params);

		//if(!"000".equals((String)params.get("errCode"))){
		//	throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		//}
	}

	// 5. Non Homecare serial STO reverse
	@Override
	public void reverseSerialCode(Map<String, Object> params) throws Exception{
		serialMgmtNewMapper.callReverseBarcodeScan(params);
	}

	// Stock Audit serial delete
	@Override
	public void deleteAdSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		serialMgmtNewMapper.callAdDeleteBarcodeScan(params);

		if(!"000".equals((String)params.get("errCode"))){
			throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		}
	}

	// Stock Audit serial delete
	@Override
	public void deleteOgOiSerial(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		serialMgmtNewMapper.callOgOiDeleteBarcodeScan(params);

		if(!"000".equals((String)params.get("errCode"))){
			throw new ApplicationException(AppConstants.FAIL, (String)params.get("errMsg"));
		}
	}

	@Override
	public EgovMap selectItemSerch(Map<String, Object> params) throws Exception{
		return serialMgmtNewMapper.selectItemSerch(params);
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

	// homecare serial - supplier code check.
	private boolean validationSupplierCode(List<EgovMap> list, String supCode){
		if(list == null || list.size() < 1){
			return false;
		}

		if(StringUtils.isEmpty(supCode)){
			return false;
		}

		boolean check = false;
		for(EgovMap mCode : list){
			if( supCode.equals((String)mCode.get("code")) ){
				check = true;
				break;
			}
		}

		return check;
	}

	@Override
	public String selectBoxSerialBarcode(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		String serialBarcode = "";
		List<EgovMap> serialBarcodeList = serialMgmtNewMapper.selectBoxSerialBarcode(params);

		for (EgovMap obj : serialBarcodeList) {
			serialBarcode = serialBarcode + obj.get("serialNo").toString();
		}

		return serialBarcode;
	}

	@Override
	public void saveSerialNo(Map<String, Object> params, SessionVO sessionVo) throws Exception{ // HLTANG 202111 - filter barcode scan
		String[] arrReqstNo = params.get("reqstNo").toString().split(",");
		params.put("arrReqstNo", arrReqstNo);
		List<EgovMap> grListmain = serialMgmtNewMapper.selectSerialInfoMul(params);

		Map<String, Object> mainMap = null;
		for (Object obj : grListmain) {
			mainMap = (Map<String, Object>) obj;
			serialMgmtNewMapper.updateDeliveryGrDetail(mainMap);//log0099m
			serialMgmtNewMapper.updateDeliveryGrMain(mainMap);//log0100m
			serialMgmtNewMapper.updateDeliveryGrHist(mainMap);//log0101h
		}
	}

	@Override
	public int clearSerialNo(Map<String, Object> params, SessionVO sessionVO) throws Exception{ // HLTANG 202111 - filter barcode scan
		int saveCnt = 0;
		params.put("crtUserId", sessionVO.getUserId());
		params.put("updUserId", sessionVO.getUserId());

		Map<String, Object> sMap = new HashMap<String, Object>();
		String reqstNo = params.get("reqstNo") != null ? params.get("reqstNo").toString() : "";
		if(reqstNo.equals("")){
			sMap.put("reqstNo", (String)params.get("grNo"));
		}else{
			sMap.put("reqstNo", (String)params.get("reqstNo"));
		}
		sMap.put("ioType", (String)params.get("ioType"));
		List<EgovMap> infoList = serialMgmtNewMapper.selectSerialInfo(sMap);


		sMap.put("updUserId", sessionVO.getUserId());
		sMap.put("crtUserId", sessionVO.getUserId());
		sMap.put("scanNo", (String)params.get("scanNo"));

//		Map<String, Object> oMap = null;
//		for(EgovMap info : infoList){
//			oMap = new HashMap<String, Object>();
//			oMap.put("updUserId", sessionVO.getUserId());
//			oMap.put("crtUserId", sessionVO.getUserId());
//			oMap.put("boxno", (String)info.get("serialNo"));
//			oMap.put("ioType", (String)params.get("ioType"));
//			oMap.put("scanNo", (String)params.get("scanNo"));
//			oMap.put("delvryNo", (String)info.get("delvryNo"));
//			oMap.put("scanNo", (String)info.get("scanNo"));
//			oMap.put("reqstNo", (String)info.get("reqstNo"));
//
//			// LOG0101H -- LOG0100M --
//			serialMgmtNewMapper.copySerialMasterHistory(oMap);
//
//			// LOG0099D
////			serialMgmtNewMapper.deleteSerialInfo(oMap);
//
//			// LOG0100M -- State : N - update
//			oMap.put("stusCode", "N");
//			//serialMgmtNewMapper.deleteSerialMaster(oMap);
//
////			serialMgmtNewMapper.deleteTempSerialMaster(oMap);
//
//			saveCnt++;
//		}

		serialMgmtNewMapper.copySerialMasterHistoryBulk(sMap);
		serialMgmtNewMapper.deleteTempSerialMasterBulk(sMap);
		serialMgmtNewMapper.deleteSerialInfoBulk(sMap);


		saveCnt++;

		return saveCnt;
	}
}