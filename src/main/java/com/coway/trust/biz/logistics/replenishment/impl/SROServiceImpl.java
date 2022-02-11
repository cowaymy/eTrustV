
/**
 * @author LEO
 *
 */
package com.coway.trust.biz.logistics.replenishment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.replenishment.SROService;
import com.coway.trust.biz.logistics.stockmovement.StockMovementService;
import com.coway.trust.biz.logistics.stocktransfer.StockTransferService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SROService")
public class SROServiceImpl extends EgovAbstractServiceImpl implements SROService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource(name = "SROMapper")
	private SROMapper replenishment;


	@Resource(name = "stocktranService")
	private StockTransferService stock;

	@Resource(name = "stockMovementService")
	private StockMovementService stockMovementService;


	@Resource(name = "SROMapper")
	private SROMapper sROMapper;


	@Override
	public List<EgovMap> sroItemMgntList(Map<String, Object> params) {
		return replenishment.sroItemMgntList(params);
	}

	@Override
	public List<EgovMap> sroMgmtList(Map<String, Object> params) {
		return replenishment.sroMgmtList(params);
	}


	@Override
	public List<EgovMap> selectSroCodeList(Map<String, Object> params) {
		return replenishment.selectSroCodeList(params);
	}



	@Override
	public List<EgovMap> sroMgmtDetailList(Map<String, Object> params) {

		if(CommonUtils.isEmpty(params.get("srono"))) {
			throw new ApplicationException(AppConstants.FAIL, "SRO No is 	Required. ");
		}

		return replenishment.sroMgmtDetailList(params);
	}


	@Override
	public List<EgovMap> sroMgmtDetailListPopUp(Map<String, Object> params) {

		if(CommonUtils.isEmpty(params.get("srono"))) {
			throw new ApplicationException(AppConstants.FAIL, "SRO No is 	Required. ");
		}

		return replenishment.sroMgmtDetailListPopUp(params);
	}




	@Override
	public void  saveSroItemMgnt(Map<String, ArrayList<Object>> params,SessionVO sessionVO)  {

			List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 				// Get grid addList
			List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE); 	// Get gride UpdateList
			List<Object> deleteList = params.get(AppConstants.AUIGRID_REMOVE);  	// Get grid DeleteList

    		int loginId = 0;
    		if(sessionVO != null){
    			loginId = sessionVO.getUserId();
    		}

    		if(  null != addList ){
    			if(addList.size() >0){
            		for (Object list : addList){
            			Map<String, Object> map = (Map<String, Object>) list;
            			map.put("updUserId", loginId);
            			replenishment.updateSroItem(map);
            		}
    			}
    		}


    		if(  null != updateList ){
    			if(updateList.size() >0){
            		for (Object list : updateList){
            			Map<String, Object> map = (Map<String, Object>) list;
            			map.put("updUserId", loginId);

            			replenishment.updateSroItem(map);
            		}
    			}
    		}
	}







	@Override
	public String  saveSroMgmt(Map<String, Object> params , SessionVO sessionVO) {

		String stoNo ="";

		if(CommonUtils.isEmpty(params.get("srono"))) {
			throw new ApplicationException(AppConstants.FAIL, "SRO No is 	Required. ");
		}

		if(CommonUtils.isEmpty(params.get("srotype"))) {
			throw new ApplicationException(AppConstants.FAIL, "SRO Type(SRO/STO)  is Required. ");
		}


		if("STO".equals(params.get("srotype"))) stoNo = callStocktransferAdd(params,  sessionVO);
		else stoNo = callStockMovementAdd(params,  sessionVO);


		logger.debug(" stoNo  재고 없음 ========> {}" ,stoNo);
		if(CommonUtils.isEmpty(stoNo)) {
			throw new ApplicationException(AppConstants.FAIL, "Check the stock of CDC ");
		}


		String  seq = replenishment.selectSROSeq();


		logger.debug(" seq =========> {}" ,seq);
		if(CommonUtils.isEmpty(seq)) {
			throw new ApplicationException(AppConstants.FAIL, "SRO(seq) No is 	Required. ");
		}

		if(CommonUtils.isEmpty(params.get("srostkcode"))) {
			throw new ApplicationException(AppConstants.FAIL, "STK CODE  is 	Required. ");
		}


		params.put("updUserId", sessionVO.getUserId());
		params.put("newsrono", seq);



		int r11 =-1;
		int r12 =-1;

		r11= replenishment.insertLOG0111D(params);
		if(r11>0)  r12 = replenishment.insertLOG0112D(params);

		if(r12 ==0) 	throw new ApplicationException(AppConstants.FAIL, "  Auto Replenishment Master  data  not found");





		//update  LOG0112D
		if(r12>0){

			 /**************************
		       * delete sro  by leo.ham
		       **************************/
		       Map<String, Object> sroMap = new HashMap<String, Object>();
		       sroMap.put("refno", seq);
		       sroMap.put("userId", sessionVO.getUserId());
		       sroMap.put("type", "STO");
		       sroMap.put("result", "CM");
		       sroMap.put("item",params.get("srostkcode"));

		       logger.debug("=====>",sroMap.toString());
		       sROMapper.SP_LOGITIC_SRO_UPDATE(sroMap);

		       /**************************
		        * delete sro  by leo.ham
		        **************************/




			// int  upr12 =  replenishment.updateLOG0112D(params);

			 				  //replenishment.updateStateLOG0112D(params);

			 				  // params.put("reqno", stoNo);
			 				  // replenishment.updateReqNoLOG0111D(params);
		}


		return stoNo;
	}


	@Override
	public void deleteUpdateLOG0112D(List <EgovMap>params, SessionVO sessionVO) {
		// TODO Auto-generated method stub


		int loginId = 0;
		if(sessionVO != null){
			loginId = sessionVO.getUserId();
		}

		if(  null != params ){
			if(params.size() >0){

				for (Object list : params){

					 Map<String, Object> map = (Map<String, Object>) list;

        			 logger.debug(map.get("item").toString());
        		 	 map.put("updUserId", loginId);
        			//replenishment.deleteUpdateLOG0112D((Map)map.get("item"));

				     /**************************
				       * delete sro  by leo.ham
				       **************************/
				       Map<String, Object> sroMap = new HashMap<String, Object>();
				       sroMap.put("refno", ((Map)map.get("item")).get("srono").toString() );
				       sroMap.put("userId", loginId);
				       sroMap.put("type", "STO");
				       sroMap.put("result", "DW");
				       sroMap.put("item", ((Map)map.get("item")).get("srostkcode").toString());

				       logger.debug("=====>",sroMap.toString());
				       sROMapper.SP_LOGITIC_SRO_UPDATE(sroMap);

				       /**************************
				        * delete sro  by leo.ham
				        **************************/


				}
			}
		}

	}


	public  String   callStocktransferAdd (Map<String, Object>  obj   ,SessionVO sessionVO){

		String  stoNo="";

    	Map<String, Object> params  = new HashMap();
    	List<Map<String, Object>>  plist = new ArrayList<Map<String, Object>> ();
    	Map<String, Object> fMap  = new HashMap<String, Object>();
    	Map<String, Object> imap =  new HashMap<String, Object>();



    	List<EgovMap>   stoBasicDataList  = replenishment.selectSTODataInfo(obj);

    	if(! CommonUtils.isEmpty(stoBasicDataList)) {
    		for (Object sList : stoBasicDataList){
    			Map<String, Object> map = (Map<String, Object>) sList;

    	    	fMap.put("tlocation",map.get("flocation"));
    	    	fMap.put("flocation", map.get("tlocation"));

    	    	//fMap.put("tlocation",map.get("tlocation"));
    	    	//fMap.put("flocation", map.get("flocation"));
    	    	//selectAvaliableStockQty   flocation 이 바뀌어 있음
    	    	//stockMoveMapper.selectAvaliableStockQty(insMap);




    	    	fMap.put("reqcrtdate" ,map.get("reqcrtdate"));
    	    	fMap.put("dochdertxt" ,map.get("dochdertxt") );
    	    	fMap.put("sttype", map.get("sttype"));	     //US
    	    	fMap.put("smtype", map.get("smtype"));   // "US03"
    	    	fMap.put("pridic", map.get("pridic"));		//M

    	    	fMap.put("userId", sessionVO.getUserId());


    	    	imap.put("itmid",  map.get("itmid"));
    	    	imap.put("itmcd", map.get("itmcd"));
    	    	imap.put("itmname", map.get("itmname"));
    	    	imap.put("aqty", map.get("aqty"));
    	    	imap.put("uom", map.get("uom"));
    	    	imap.put("rqty", map.get("rqty"));
    	    	imap.put("userId", sessionVO.getUserId());

    	    	plist.add(imap);

    		}
    	}


    	params.put("add", plist);
    	params.put("form", fMap);

    	stoNo = stock.insertStockTransferInfo(params);



		return stoNo;
	}



	public  String   callStockMovementAdd (Map<String, Object>  obj   ,SessionVO sessionVO){

		String  stoNo="";

    	Map<String, Object> params  = new HashMap();
    	List<Map<String, Object>>  plist = new ArrayList<Map<String, Object>> ();
    	Map<String, Object> fMap  = new HashMap<String, Object>();
    	Map<String, Object> imap =  new HashMap<String, Object>();



    	List<EgovMap>   stoBasicDataList  = replenishment.selectSMODataInfo(obj);

    	if(! CommonUtils.isEmpty(stoBasicDataList)) {
    		for (Object sList : stoBasicDataList){
    			Map<String, Object> map = (Map<String, Object>) sList;

    			/*******************/
    	    	//fMap.put("tlocation",map.get("tlocation"));
    	    	//fMap.put("flocation", map.get("flocation"));
    	    	//selectAvaliableStockQty   flocation 이 바뀌어 있음
    	    	//stockMoveMapper.selectAvaliableStockQty(insMap);

    	    	fMap.put("tlocation",map.get("flocation"));
    	    	fMap.put("flocation", map.get("tlocation"));

    	    	/******************/

    	    	fMap.put("reqcrtdate", map.get("reqcrtdate"));
    	    	fMap.put("headtitle", map.get("headtitle"));
    	    	fMap.put("dochdertxt",map.get("dochdertxt") );
    	    	fMap.put("sttype", map.get("sttype"));	     //US
    	    	fMap.put("smtype", map.get("smtype"));   // "US03"
    	    	fMap.put("pridic", map.get("pridic"));		 //M
    	      	fMap.put("movpath", map.get("movpath"));
    	      	fMap.put("docdate", map.get("docdate"));
    	    	fMap.put("userId", sessionVO.getUserId());

    	    	imap.put("itmid",  map.get("itmid"));
    	    	imap.put("itmcd", map.get("itmcd"));
    	    	imap.put("itmname", map.get("itmname"));
    	    	imap.put("aqty", map.get("aqty"));
    	    	imap.put("uom", map.get("uom"));
    	    	imap.put("rqty", map.get("rqty"));
    	    	imap.put("itmserial", map.get("itmserial"));
    	    	imap.put("itmtype", map.get("itmtype"));

    	    	imap.put("userId", sessionVO.getUserId());

    	    	plist.add(imap);

    		}
    	}

    	params.put("add", plist);
    	params.put("form", fMap);

    	stoNo = stockMovementService.insertStockMovementInfo(params);

		return stoNo;
	}



}
