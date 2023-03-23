package com.coway.trust.biz.sales.pos.impl;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.pos.PosStockService;
import com.coway.trust.biz.sales.pos.vo.PosDetailVO;
import com.coway.trust.biz.sales.pos.vo.PosGridVO;
import com.coway.trust.biz.sales.pos.vo.PosLoyaltyRewardVO;
import com.coway.trust.biz.sales.pos.vo.PosMasterVO;
import com.coway.trust.biz.sales.pos.vo.PosMemberVO;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.sales.SalesConstants;
import com.ibm.icu.math.BigDecimal;
import com.uwyn.jhighlight.fastutil.Hash;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("posStockService")
public class PosStockServiceImpl extends EgovAbstractServiceImpl implements PosStockService {

  private static final Logger LOGGER = LoggerFactory.getLogger(PosStockServiceImpl.class);

  @Resource(name = "posStockMapper")
  private PosStockMapper posMapper;



@Override
public Map<String, Object> insertPosStock(Map<String, Object> params) throws Exception {


	int seq = 0;

	String sal0293Seq ="";

	List<Object> addList = (List<Object>) params.get("add");


	seq=posMapper.getSeqSAL0293M();
	sal0293Seq ="SCN"+CommonUtils.getFillString(Integer.toString(seq), "0",10,"RIGHT");


	Map<String, Object>  heardMap  = null;
	String scnFromLocId =null;

	if(addList != null){

		heardMap= new HashMap<String, Object>();
		scnFromLocId= (String)((Map<String, Object>)addList.get(0)).get("scnFromLocId");

		heardMap.put("scnFromLocId", scnFromLocId);
		heardMap.put("scnNo", sal0293Seq);
		heardMap.put("scnMoveType", params.get("scnMoveType"));
		heardMap.put("userId", params.get("userId"));

		posMapper.insertSAL0293M(heardMap);



		for (int i = 0; i < addList.size(); i++) {
		      Map<String, Object> addMap = (Map<String, Object>)addList.get(i);


		      LOGGER.debug(" addList===>"+addMap.toString());
		      addMap.put("scnNo", sal0293Seq);
		      addMap.put("userId", params.get("userId"));

		      //return
		      if(params.get("scnMoveType").equals("R")){
		    	  addMap.put("itemRtnQty", addMap.get("itemReqQty"));
		      }
		      posMapper.insertSAL0294D(addMap);

		 }
	}



	   // retrun Map
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("scnNo", sal0293Seq);
    return rtnMap;

}



@Override
public List<EgovMap> selectPosStockMgmtList(Map<String, Object> params) throws Exception {
	 return posMapper.selectPosStockMgmtList(params);
 }

@Override
public List<EgovMap> selectPosStockMgmtDetailsList(Map<String, Object> params) throws Exception {
	 return posMapper.selectPosStockMgmtDetailsList(params);
 }



@Override
public EgovMap selectPosStockMgmtViewInfo(Map<String, Object> params) throws Exception {
	return 	 posMapper.selectPosStockMgmtViewInfo(params);
}



@Override
public List<EgovMap> selectPosStockMgmtViewList(Map<String, Object> params) throws Exception {
	return 	  posMapper.selectPosStockMgmtViewList(params);
}



@Override
public Map<String, Object> insertTransPosStock(Map<String, Object> params) throws Exception {



	int seq = 0;

	String sal0293Seq ="";

	List<Object> addList = (List<Object>) params.get("add");


	seq=posMapper.getSeqSAL0293M();
	sal0293Seq ="SCN"+CommonUtils.getFillString(Integer.toString(seq), "0",10,"RIGHT");


	Map<String, Object>  heardMap  = null;
	String scnFromLocId =null;
	String scnToLocId =null;

	if(addList != null){

		heardMap= new HashMap<String, Object>();
		scnFromLocId  = (String)((Map<String, Object>)addList.get(0)).get("scnFromLocId");
		scnToLocId		= (String)((Map<String, Object>)addList.get(0)).get("scnToLocId");

		heardMap.put("scnFromLocId", scnFromLocId);
		heardMap.put("scnToLocId", scnToLocId);
		heardMap.put("scnNo", sal0293Seq);
		heardMap.put("scnMoveType", "T");
		heardMap.put("userId", params.get("userId"));

		posMapper.insertSAL0293M(heardMap);

		for (int i = 0; i < addList.size(); i++) {
		      Map<String, Object> addMap = (Map<String, Object>)addList.get(i);

		      addMap.put("scnNo", sal0293Seq);
		      addMap.put("userId", params.get("userId"));
		      addMap.put("itemStatus", params.get("A"));
		      posMapper.insertSAL0294D(addMap);

		 }
		 posMapper.updateFloatingStockLOG0106M(heardMap);

	}



	   // retrun Map
    Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("scnNo", sal0293Seq);
    return rtnMap;
}



@Override
public Map<String, Object> updateRecivedPosStock(Map<String, Object> params) throws Exception {

	List<Object> upList = (List<Object>) params.get("update");
    Map<String, Object> upHMap = new HashMap<String, Object>();

    String scnNo = params.get("scnNo").toString();

    upHMap.put("scnNo",scnNo);
    upHMap.put("userId", params.get("userId"));
    params.put("scnNo", scnNo);

    EgovMap  master = posMapper.selectPosStockMgmtViewInfo(params);

    int completCnt =0;

    for (int i = 0; i < upList.size(); i++) {
        	Map<String, Object> upMap = (Map<String, Object>)upList.get(i);

    	  	if ("R".equals(upMap.get("itemStatus").toString())){
    	  	   posMapper.updateReceviedRejectSAL0294D(upMap);
    	  	}
    	  	else{

	  			upMap.put("itemRecvQty", upMap.get("itemReqQty"));
	  			upMap.put("userId", params.get("userId"));
	  			posMapper.updateReceviedSAL0294D(upMap);

	  			//Stock In  STOCK IN (I) ,STOCK TRANSFER (T), ADJUSTMENT(A)
	  			String[] movementType = { "A","T","I" };
	  			List movementTypeList = Arrays.asList(movementType);
	  			if(movementTypeList.contains(master.get("scnMoveType")))
	  			{
	  				  upMap.put("logId", master.get("scnMoveType").toString().equals("T") ?   master.get("scnToLocId") : master.get("scnFromLocId"));
        	    	  upMap.put("itemInvQty", upMap.get("itemRecvQty"));
        	    	  posMapper.updateMergeLOG0106M(upMap);
	  			}
          	  completCnt++;
    	  }
    }


    if (completCnt >0){
    	 upHMap.put("scnMoveStat","C");
    }else {
      	 upHMap.put("scnMoveStat","R");
      	 params.put("userId", params.get("userId"));
      	 if((master.get("scnMoveType")).toString().equals("T")){
      		posMapper.updateRejectedFloatingStockLOG0106M(params);
      	}
    }

   	posMapper.updateReceviedSAL0293M(upHMap);

	Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("isOk", "OK");

	return rtnMap;
}


@Override
public Map<String, Object> updateApprovalPosStock(Map<String, Object> params) throws Exception {

	List<Object> upList = (List<Object>) params.get("update");

    Map<String, Object> upHMap = new HashMap<String, Object>();

    String scnNo = params.get("scnNo").toString();

    upHMap.put("scnNo",scnNo);
    upHMap.put("scnMoveStat","C");
    upHMap.put("userId", params.get("userId"));


    params.put("scnNo", scnNo);
    EgovMap  master = posMapper.selectPosStockMgmtViewInfo(params);

    int completCnt =0;


        for (int i = 0; i < upList.size(); i++) {
        	  Map<String, Object> upMap = (Map<String, Object>)upList.get(i);

        	  	if ("R".equals(upMap.get("itemStatus").toString())){
        	  	   posMapper.updateReceviedRejectSAL0294D(upMap);

        	  	}else{

        	  		    /******************중요***********************/
        	  			//upMap.put("itemRecvQty", upMap.get("itemReqQty"));
        	  		    /**************************************/


        	  			upMap.put("userId", params.get("userId"));
        	  			posMapper.updateApprovalSAL0294D(upMap);


        	  		    upMap.put("logId", master.get("scnFromLocId")); //stock out
          	    	    //upMap.put("itemInvQty", upMap.get("itemRtnQty"));
          	  	        upMap.put("itemRecvQty", upMap.get("itemRtnQty"));
          	    	    posMapper.updateOutStockLOG0106M(upMap);

          	     	  	 completCnt++;

                  	     //posMapper.updateMergeLOG0106M(upMap);
        	  		 }
        }


        if (completCnt >0){
       	 upHMap.put("scnMoveStat","C");
       }else {
         	 upHMap.put("scnMoveStat","R");
       }

       	posMapper.updateReceviedSAL0293M(upHMap);
  //  }



	Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("isOk", "OK");

	return rtnMap;
}



@Override
public Map<String, Object> updateAdjPosStock(Map<String, Object> params) throws Exception {

	List<Object> upList = (List<Object>) params.get("update");

    Map<String, Object> upHMap = new HashMap<String, Object>();


    String scnNo  =((Map<String, Object>)upList.get(0)).get("scnNo").toString();

    upHMap.put("scnNo",scnNo);
    upHMap.put("userId", params.get("userId"));


    params.put("scnNo", scnNo);
    EgovMap  master = posMapper.selectPosStockMgmtViewInfo(params);


	for (int i = 0; i < upList.size(); i++) {
	      Map<String, Object> upMap = (Map<String, Object>)upList.get(i);
	      upMap.put("userId", params.get("userId"));
	      posMapper.updateAdjSAL0294D(upMap);


	      LOGGER.debug("==========================");
	      LOGGER.debug(upMap.toString());


	      upMap.put("logId", master.get("scnToLocId")); //stock out
	      upMap.put("itemCtgryCode", master.get("itemCtgryId"));
    	  upMap.put("itemRecvQty", upMap.get("itemAdjQty"));
    	  posMapper.updateLOG0106M(upMap);


	 }



	Map<String, Object> rtnMap = new HashMap<String, Object>();
    rtnMap.put("isOk", "OK");

	return rtnMap;
}



@Override
public EgovMap selectItemInvtQty(Map<String, Object> params) throws Exception {


	return   posMapper.selectItemInvtQty(params);
}



@Override
public List<EgovMap> selectPosItmList(Map<String, Object> params) throws Exception {

	return 	(List<EgovMap>) posMapper.selectPosItmList(params);
}

}
