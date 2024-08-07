package com.coway.trust.biz.logistics.pst.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.pst.PstService;
import com.coway.trust.biz.logistics.stockmovement.impl.StockMovementMapper;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pstService")
public class PstServiceImpl extends EgovAbstractServiceImpl implements PstService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "PstMapper")
	private PstMapper pst;

	@Resource(name = "stockMoveMapper")
	private StockMovementMapper stockMoveMapper;

	@Override
	public List<EgovMap> PstSearchList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pst.PstSearchList(map);
	}
	@Override
	public void pstMovementReqDelivery(Map<String, Object> params) {
		int userId = (int)params.get("userId");
		//BillOrderInsert(params , userId);
		// TODO Auto-generated method stub
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		List<Object> serialList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		String reqstSeq = "";
		int psoid    = 0;
		int totalPrice = 0;
		if (checkList.size() > 0) {
			Map<String, Object> insMap = null;
			Map<String, Object> mainDMap = new HashMap<String, Object>();
			Map<String, Object> mainMap = new HashMap();
			String tmpPstid = "";
			boolean bool = true;
			for (int i = 0 ; i < checkList.size(); i++){
				Map<String, Object> tmp = (Map<String, Object>) checkList.get(i);//.get("item");
				int iCnt = 0;
				insMap = (Map<String, Object>)tmp.get("item");

				String movtype = "";
				String movtypecode = "";
				if ((int)insMap.get("invtype")==5708){
				if ((int)insMap.get("psttypeid")==2577){
					movtype = "OD17";
				}else if((int)insMap.get("psttypeid")==2578){
					movtype = "OD18";
				}else if((int)insMap.get("psttypeid")==2579){
					movtype = "OD19";
				}else{
					movtype = "OD20";
				}
				movtypecode = "OD";
				}
				if ((int)insMap.get("invtype")==5709){
					if ((int)insMap.get("psttypeid")==2577){
						movtype = "PS01";
					}else if((int)insMap.get("psttypeid")==2578){
						movtype = "PS02";
					}else if((int)insMap.get("psttypeid")==2579){
						movtype = "PS03";
					}else{
						movtype = "PS04";
					}
					movtypecode = "PS";
				}
				insMap.put("movetype" , movtype);
				insMap.put("movetypecode" , movtypecode);
				insMap.put("userid"   , userId);
				insMap.put("htext", formMap.get("doctext"));
				if (!tmpPstid.equals((String)insMap.get("psono"))){
					reqstSeq = pst.selectPstMovementSeq(); // 요청번호 채번
					//logger.debug(" 요청번호 채번!!!!!!!! {} " + reqstSeq);
					tmpPstid = (String)insMap.get("psono");
					insMap.put("reqno"    , reqstSeq);

					pst.pstRequestInsert(insMap);
				}
				insMap.put("reqno"    , reqstSeq);
				iCnt = Integer.parseInt((String)insMap.get("reqqty"));

				pst.pstRequestInsertDetail(insMap);

				if (insMap.get("serialchk") != null && "Y".equals((String)insMap.get("serialchk"))){
					// serial등록
					int scnt = 0;
					for (int j = 0 ; j < serialList.size(); j++){
						Map<String, Object> stmp = (Map<String, Object>) serialList.get(j);//.get("item");
						logger.debug("76Line ::: {} " + stmp);
						stmp.put("reqstno", reqstSeq);
						stmp.put("userid" , userId);
						if (((String)stmp.get("itmcd")).equals((String)insMap.get("itmcd"))){
							int icnt = pst.insertMovementSerial(stmp);
							scnt = scnt + icnt;
						}

						if (iCnt == scnt ){
							scnt = 0;
							break;
						}
					}
				}
				psoid = (int)insMap.get("psoid");

				//logger.debug(" :::: " + (double)insMap.get("itmprc"));
				//logger.debug(" :::: " + (int)insMap.get("itmprc"));
				try{
					totalPrice = totalPrice+(Integer.parseInt((String)insMap.get("reqqty")) * (int)insMap.get("itmprc"));
				}catch(Exception ex){
					totalPrice = totalPrice+(Integer.parseInt((String)insMap.get("reqqty")) * (int)((double)insMap.get("itmprc")));
				}
				pst.updatePSTsalesDetail(insMap);
				pst.insertPSTsalesLog(insMap);
				if (bool && ((int)insMap.get("balqty") - Integer.parseInt((String)insMap.get("reqqty")) == 0)){
					bool = true;
				}else{
					bool = false;
				}

				mainMap.put("psoid"  , psoid                   );
				mainMap.put("psttype", insMap.get("psttypeid") );
				mainMap.put("locid"  , insMap.get("dealerid")  );

				insMap.put("itemNo", (i+1));

				pst.insertStockCardList(insMap);

			}

			int statusId = 0;
			if (bool){
				statusId = 4;
			}else{
				statusId = 1;
			}
			mainMap.put("pststatusid", statusId              );
			mainMap.put("reqstno"    , reqstSeq              );
			mainMap.put("totalprice" , totalPrice            );
			mainMap.put("dostatusid" , 4                     );
			mainMap.put("htext"      , formMap.get("doctext"));
			mainMap.put("userid"     , userId                );

			int pstdoid = pst.selectPstSalseDoMasterId();
			pst.updatePSTsalesMaster(mainMap);
			mainMap.put("pstdoid", pstdoid);
			pst.insertPSTsalesDOM(mainMap);

			logger.debug(" 11mainMap?????? {} " , mainMap);

			for (int j = 0; j < checkList.size(); j++) {

				Map<String, Object> tmp1 = (Map<String, Object>) checkList.get(j);//.get("item");
				mainDMap = (Map<String, Object>)tmp1.get("item");
				logger.debug(" 11mainDDDDDDDMap?????? {} " , mainDMap);
				int pstDetailId = pst.selectPstSalseDetailId();

				//2577 , 2579
				int zreexptid = 0;
				try{
					zreexptid = pst.getZrExportationIDByPOSID(psoid);
				}catch(Exception ex){
					zreexptid = 0;
				}
				int taxcodeid = 0;
				int taxrate   = 0;
				if (zreexptid != 0 )
		        {
					taxcodeid = 38;//TaxCodeID = 38; //ZE
					taxrate   = 0;//TaxRate = 0;
		        }
		        else
		        {
		        	taxcodeid = 32;//TaxCodeID = 32; //SR
		        	taxrate   = 0;//TaxRate = 6;
		        }

				if (taxrate > 0){
					mainDMap.put("gstrate", taxrate);
				}else{
					mainDMap.put("gstrate", 0);
				}
				mainDMap.put("pstDetailId", pstDetailId);
				mainDMap.put("pstdoid", pstdoid);
				mainDMap.put("taxrate", taxrate);
				mainDMap.put("taxcodeid", taxcodeid);

				pst.insertPSTsalesDOMD(mainDMap);

			}


			BillOrderInsert(params , userId , reqstSeq);
			//LOG0014D

			//material document insert
			//reqstSeq
			String mdnNo = pst.selectMdnNo();
			List<EgovMap> reqlist = pst.selectRequestData(reqstSeq);

			for (int i = 0 ; i < reqlist.size() ; i++){
				Map<String, Object> dmap = (Map<String, Object>)reqlist.get(i);
				logger.debug(" ::::: {} " , dmap);
				dmap.put("mdnno", mdnNo);
				dmap.put("psoid", String.valueOf(psoid));
				dmap.put("userid" , userId);
				if (i == 0){
					pst.pstMaterialDocumentInsert(dmap);
				}
				pst.pstMaterialDocumentInsertDetail(dmap);
				pst.pstMaterialStockBalance(dmap);

				if ("S".equals(((String)dmap.get("DEBIT")))){
					pst.pstMaterialStockSerialInsert(dmap);
				}else{
					pst.pstMaterialStockSerialDelete(dmap);
				}
			}

		}
	}

	public void BillOrderInsert(Map<String, Object> params , int userId , String reqstSeq) {
		List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		List<Map<String , Object>> invoiceList = new ArrayList<>();
		Map<String, Object> insMap = null;
		String tmpPstid = "";
		boolean bool = true;
		int psttype = 0;
		int reqqty = 0;
		double charge = 0.0;
		double incharge = 0.0;
		int pstinvtype = 0;
		int wholesale = 0;
		int compensation = 0;

		//Map<String , Object> invoiceD = new HashMap();

		Map<String , Object> ordMap = new HashMap();
	//	ordMap.put("reqstno", reqstSeq);
	//	ordMap.put("reqstno", reqstSeq);
		int psoid = 0;
		for (int i = 0 ; i < checkList.size(); i++){
			Map<String , Object> invoiceD = new HashMap();
		//	logger.debug(" :::??????checkList??????? {} ", checkList.get(i));
			Map<String, Object> tmp = (Map<String, Object>) checkList.get(i);//.get("item");
			int iCnt = 0;
			insMap  = (Map<String, Object>)tmp.get("item");
		//	logger.debug("------------------------------------- insMap---------------- -------{} ", insMap);

			psoid   = (int)insMap.get("psoid");
			psttype = (int)insMap.get("psttypeid");
			reqqty  = Integer.parseInt((String)insMap.get("reqqty"));
			pstinvtype = (int)insMap.get("invtype");
			ordMap  = insMap;
			if (psttype == 2577 || 2579 == psttype){
				if (reqqty > 0 ){
					logger.debug(" :::: " + String.valueOf(insMap.get("pcr")));
					try{
						charge = charge + (double)(reqqty * (int)insMap.get("itmprc") * Double.parseDouble(String.valueOf(insMap.get("pcr"))));
					}catch(Exception ex){
						charge = charge + (reqqty * (double)insMap.get("itmprc") * Double.parseDouble(String.valueOf(insMap.get("pcr"))));
					}

					try{
						incharge = incharge + (reqqty * (int)insMap.get("itmprc"));
					}catch(Exception ex){
						incharge = incharge + (reqqty * (double)insMap.get("itmprc"));
					}

				}
			}
			invoiceD.put("itemtype", 1272);
			invoiceD.put("itemordno", "");
			invoiceD.put("pstpo", insMap.get("pstpo"));
			invoiceD.put("itmcd", insMap.get("itmcd"));
			invoiceD.put("itmnm1", insMap.get("itmnm"));
			invoiceD.put("itmnm2", "");
			invoiceD.put("serialno", "");
			invoiceD.put("reqqty", insMap.get("reqqty"));
			invoiceD.put("itmprc", insMap.get("itmprc"));

			//logger.debug(" :::??????요청수량?????????? {} ", insMap.get("reqqty"));

			invoiceList.add(invoiceD);
			//logger.debug(" :::??????hamTestttttttttttttttt??????? {} ", invoiceList.get(i));
		}

		//2577 , 2579
		int zreexptid = 0;
		try{
			zreexptid = pst.getZrExportationIDByPOSID(psoid);
		}catch(Exception ex){
			zreexptid = 0;
		}
		int taxcodeid = 0;
		int taxrate   = 0;
		if (zreexptid != 0 )
        {
			taxcodeid = 38;//TaxCodeID = 38; //ZE
			taxrate   = 0;//TaxRate = 0;
        }
        else
        {
        	taxcodeid = 32;//TaxCodeID = 32; //SR
        	taxrate   = 0;//TaxRate = 6;
        }

		ordMap.put("userid", userId);

		if (psttype == 2577 || 2579 == psttype){
			double taxed = 0.0;
			if (taxrate > 0){
				taxed = charge * taxrate;
			}
			int docno = 129;
			String invoiceno    = pst.invoiceDocNoSelect(docno);

			taxed = incharge*0.00;

			//ordMap.put("schaount", charge + taxed);
			ordMap.put("schaount", incharge + taxed);
			//ordMap.put("billnet", taxed);
			ordMap.put("billnet", taxed);
			ordMap.put("taxrate", taxrate);
			ordMap.put("taxcodeid", taxcodeid);
			ordMap.put("invoiceno", invoiceno);
			if (pstinvtype == 5708){
				wholesale = 1271;
				ordMap.put("invtype", wholesale);
			}
			else{
				compensation = 5704;
				ordMap.put("invtype", compensation);
			}

			//orderbill
			pst.BillOrderInsert(ordMap);
			//invoiceM
			taxed = incharge*0.00;
			ordMap.put("billnet", taxed);
			ordMap.put("charges", incharge);
			ordMap.put("ammount", incharge+taxed);//dddd

			ordMap.put("reqstno", reqstSeq);

			if (pstinvtype == 5708){
				wholesale = 123;
				ordMap.put("invtype", wholesale);
			}
			else{
				compensation = 440;
				ordMap.put("invtype", compensation);
			}

			Map<String , Object> addMap = pst.selectDealerAddressMasic((int)ordMap.get("dealerid"));
			String invoicetaxid = pst.selectinvoiceTaxId();
			ordMap.put("invoicetaxid", invoicetaxid);
			if (addMap == null){
				ordMap.put("addr1", "");
				ordMap.put("addr2", "");
				ordMap.put("addr3", "");
				ordMap.put("addr4", "");
				ordMap.put("post" , "");
				ordMap.put("state", "");
				ordMap.put("cnty" , "");

			}else{
				/**ordMap.put("addr1", addMap.get("CITY"));
				ordMap.put("addr2", addMap.get("AREA"));
				ordMap.put("addr3", addMap.get("ADDR_DTL"));
				ordMap.put("addr4", "");**/

				// Edited for rearranging address layout in billing invoice. By Hui Ding, 01/11/2019
				ordMap.put("addr1", addMap.get("ADDR_DTL"));
				ordMap.put("addr2", addMap.get("STREET"));
				ordMap.put("addr3",  addMap.get("AREA"));
				ordMap.put("addr4",  addMap.get("CITY"));
				ordMap.put("areaId", addMap.get("AREA_ID"));
				ordMap.put("post" , addMap.get("POSTCODE"));
				ordMap.put("state", addMap.get("STATE"));
				ordMap.put("cnty" , addMap.get("COUNTRY"));
			}

			logger.debug(" reqstno %%%%%%%%%%% {} ", ordMap.get("reqstno"));

			pst.InvoiceMListInsert(ordMap);
			//invoiceD
			for (int i = 0 ; i < invoiceList.size(); i++){
			//	logger.debug(" :::******invoiceList******** {} ", invoiceList.get(i));
				Map<String , Object> indmap = (Map<String, Object>)invoiceList.get(i);
				String invoiceoitmid = pst.selectinvoiceItemId();
				if (taxrate > 0){
					indmap.put("gstrate", taxrate);
				}else{
					indmap.put("gstrate", 0);
				}
				indmap.put("taxinvoidid" , invoicetaxid);
				indmap.put("invoiceitmid", invoiceoitmid);

				if (pstinvtype == 5708){
					wholesale = 1272;
					indmap.put("itemtype", wholesale);
				}
				else{
					compensation = 5703;
					indmap.put("itemtype", compensation);
				}
				logger.debug(" :::!!!!!???? {} ", indmap);
				pst.InvoiceDListInsert(indmap);
			}

		}
	}



	public String pstRequestMainInsert(Map<String, Object> params) {
		String reqstSeq = pst.selectPstMovementSeq(); // 요청번호 채번

		return reqstSeq;
	}

	public void testsample(){
		Map<String , Object> addMap = pst.selectDealerAddressMasic(1);
		logger.debug(" ::: {} " , addMap);
		if (addMap == null){
			logger.debug("1111");
		}else{
			logger.debug("2222");
		}
	}
	@Override
	public List<EgovMap> PstMaterialDocViewList(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return pst.PstMaterialDocViewList(map);
	}

	// KR OHK : SMO Serial Check Popup
	@Override
	public List<EgovMap> selectPstIssuePop(Map<String, Object> params) {
	    return pst.selectPstIssuePop(params);
	}

	// KR-OHK Serial add
	@SuppressWarnings("unchecked")
	@Override
	public void pstMovementReqDeliverySerial(Map<String, Object> params) {
		int userId = (int)params.get("userId");

		//List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);

		Map<String, Object> gridList = (Map<String, Object>)  params.get("gridList");
		List<Object> checkList = (List<Object>)gridList.get(AppConstants.AUIGRID_ALL);

		String reqstSeq = "";
		int psoid    = 0;
		int totalPrice = 0;

		if (checkList.size() > 0) {
			Map<String, Object> insMap = null;
			Map<String, Object> mainDMap = new HashMap<String, Object>();
			Map<String, Object> mainMap = new HashMap<String, Object>();
			String tmpPstid = "";
			boolean bool = true;

			for (int i = 0 ; i < checkList.size(); i++){
				insMap = (Map<String, Object>) checkList.get(i);//.get("item");
				int iCnt =(int)insMap.get("reqqty");
				//insMap = (Map<String, Object>)tmp.get("item");

				if(iCnt > 0) {
    				String movtype = "";
    				String movtypecode = "";

    				if ((int)insMap.get("invtype")==5708){
        				if ((int)insMap.get("psttypeid")==2577){
        					movtype = "OD17";
        				}else if((int)insMap.get("psttypeid")==2578){
        					movtype = "OD18";
        				}else if((int)insMap.get("psttypeid")==2579){
        					movtype = "OD19";
        				}else{
        					movtype = "OD20";
        				}
        				movtypecode = "OD";
    				}

    				if ((int)insMap.get("invtype")==5709){
    					if ((int)insMap.get("psttypeid")==2577){
    						movtype = "PS01";
    					}else if((int)insMap.get("psttypeid")==2578){
    						movtype = "PS02";
    					}else if((int)insMap.get("psttypeid")==2579){
    						movtype = "PS03";
    					}else{
    						movtype = "PS04";
    					}
    					movtypecode = "PS";
    				}

    				insMap.put("movetype" , movtype);
    				insMap.put("movetypecode" , movtypecode);
    				insMap.put("userid"   , userId);
    				insMap.put("htext", formMap.get("zDoctext"));

    				if (!tmpPstid.equals((String)insMap.get("psono"))){
    					reqstSeq = pst.selectPstMovementSeq(); // 요청번호 채번
    					tmpPstid = (String)insMap.get("psono");
    					insMap.put("reqno"    , reqstSeq);

    					pst.pstRequestInsert(insMap);	//LOG0047M insert
    				}

    				insMap.put("reqno"    , reqstSeq);

    				pst.pstRequestInsertDetail(insMap); // LOG0048D insert

    				psoid = (int)insMap.get("psoid");

    				try{
    					totalPrice = totalPrice+((int)insMap.get("reqqty") * (int)insMap.get("itmprc"));
    				}catch(Exception ex){
    					totalPrice = totalPrice+((int)insMap.get("reqqty") * (int)((double)insMap.get("itmprc")));
    				}

    				pst.updatePSTsalesDetail(insMap);	// SAL0063D qty update
    				pst.insertPSTsalesLog(insMap);		// SAL0061D insert

    				if (bool && ((int)insMap.get("balqty") - (int)insMap.get("reqqty") == 0)){
    					bool = true;
    				}else{
    					bool = false;
    				}

    				mainMap.put("psoid"  , psoid                   );
    				mainMap.put("psttype", insMap.get("psttypeid") );
    				mainMap.put("locid"  , insMap.get("dealerid")  );

    				insMap.put("itemNo", (i+1));

    				pst.insertStockCardList(insMap);		// LOG0014D insert
				}
			}

			int statusId = 0;
			if (bool){
				statusId = 4;
			}else{
				statusId = 1;
			}
			mainMap.put("pststatusid", statusId              );
			mainMap.put("reqstno"    , reqstSeq              );
			mainMap.put("totalprice" , totalPrice            );
			mainMap.put("dostatusid" , 4                     );
			mainMap.put("htext"      , formMap.get("zDoctext"));
			mainMap.put("userid"     , userId                );

			int pstdoid = pst.selectPstSalseDoMasterId();
			pst.updatePSTsalesMaster(mainMap);		// SAL0062D status update
			mainMap.put("pstdoid", pstdoid);
			pst.insertPSTsalesDOM(mainMap);			// SAL0059D insert

			logger.debug(" 11mainMap?????? {} " , mainMap);

			for (int j = 0; j < checkList.size(); j++) {

				mainDMap = (Map<String, Object>) checkList.get(j);//.get("item");
				//mainDMap = (Map<String, Object>)tmp1.get("item");
				logger.debug(" 11mainDDDDDDDMap?????? {} " , mainDMap);

				int iCnt =(int)mainDMap.get("reqqty");

				if(iCnt > 0) {
    				int pstDetailId = pst.selectPstSalseDetailId();

    				//2577 , 2579
    				int zreexptid = 0;
    				try{
    					zreexptid = pst.getZrExportationIDByPOSID(psoid);
    				}catch(Exception ex){
    					zreexptid = 0;
    				}
    				int taxcodeid = 0;
    				int taxrate   = 0;
    				if (zreexptid != 0 )
    		        {
    					taxcodeid = 38;//TaxCodeID = 38; //ZE
    					taxrate   = 0;//TaxRate = 0;
    		        }
    		        else
    		        {
    		        	taxcodeid = 32;//TaxCodeID = 32; //SR
    		        	taxrate   = 0;//TaxRate = 6;
    		        }

    				if (taxrate > 0){
    					mainDMap.put("gstrate", taxrate);
    				}else{
    					mainDMap.put("gstrate", 0);
    				}
    				mainDMap.put("pstDetailId", pstDetailId);
    				mainDMap.put("pstdoid", pstdoid);
    				mainDMap.put("taxrate", taxrate);
    				mainDMap.put("taxcodeid", taxcodeid);

    				pst.insertPSTsalesDOMD(mainDMap);	// SAL0060D insert
				}
			}

			this.BillOrderInsertSerial(params , userId , reqstSeq);
			//LOG0014D

			//material document insert
			//reqstSeq
			String mdnNo = pst.selectMdnNo();
			List<EgovMap> reqlist = pst.selectRequestData(reqstSeq);

			for (int i = 0 ; i < reqlist.size() ; i++){
				Map<String, Object> dmap = (Map<String, Object>)reqlist.get(i);
				logger.debug(" ::::: {} " , dmap);
				dmap.put("mdnno", mdnNo);
				dmap.put("psoid", String.valueOf(psoid));
				dmap.put("userid" , userId);
				if (i == 0){
					pst.pstMaterialDocumentInsert(dmap);			// LOG0059M insert
				}
				pst.pstMaterialDocumentInsertDetail(dmap);		// LOG0060D insert
				pst.pstMaterialStockBalance(dmap);				// LOG0056M qty update
			}

			// SERIAL SCAN SAVE
			params.put("delvryGrDt", formMap.get("zGiptdate"));
	        params.put("reqstNo", reqstSeq);
	        params.put("trnscType",formMap.get("zTrnscType"));
	        params.put("ioType",formMap.get("zIoType"));
	        params.put("userId",userId);

	        stockMoveMapper.StockMovementIssueBarcodeSave(params);

	        String errCode = (String)params.get("pErrcode");
		    String errMsg = (String)params.get("pErrmsg");

	   	    logger.debug(">>>>>>>>>>>ERROR CODE : " + errCode);
		    logger.debug(">>>>>>>>>>>ERROR MSG: " + errMsg);

		    // pErrcode : 000  = Success, others = Fail
		    if(!"000".equals(errCode)){
			    throw new ApplicationException(AppConstants.FAIL, "[ERROR]" + errCode + ":" + errMsg);
		    }
		}
	}

	public void BillOrderInsertSerial(Map<String, Object> params , int userId , String reqstSeq) {
		//List<Object> checkList = (List<Object>) params.get(AppConstants.AUIGRID_CHECK);

		Map<String, Object> gridList = (Map<String, Object>)  params.get("gridList");
		List<Object> checkList = (List<Object>)gridList.get(AppConstants.AUIGRID_ALL);

		List<Map<String , Object>> invoiceList = new ArrayList<>();
		Map<String, Object> insMap = null;
		String tmpPstid = "";
		boolean bool = true;
		int psttype = 0;
		int reqqty = 0;
		double charge = 0.0;
		double incharge = 0.0;
		int pstinvtype = 0;
		int wholesale = 0;
		int compensation = 0;

		//Map<String , Object> invoiceD = new HashMap();

		Map<String , Object> ordMap = new HashMap();
	//	ordMap.put("reqstno", reqstSeq);
	//	ordMap.put("reqstno", reqstSeq);
		int psoid = 0;
		for (int i = 0 ; i < checkList.size(); i++){
			Map<String , Object> invoiceD = new HashMap();
		//	logger.debug(" :::??????checkList??????? {} ", checkList.get(i));
			insMap = (Map<String, Object>) checkList.get(i);//.get("item");
			int iCnt = 0;
			//insMap  = (Map<String, Object>)tmp.get("item");
		//	logger.debug("------------------------------------- insMap---------------- -------{} ", insMap);

			psoid   = (int)insMap.get("psoid");
			psttype = (int)insMap.get("psttypeid");
			reqqty  = (int)insMap.get("reqqty");
			pstinvtype = (int)insMap.get("invtype");
			ordMap  = insMap;

			if (reqqty > 0 ){
    			if (psttype == 2577 || 2579 == psttype){
    				if (reqqty > 0 ){
    					logger.debug(" :::: " + String.valueOf(insMap.get("pcr")));
    					try{
    						charge = charge + (double)(reqqty * (int)insMap.get("itmprc") * Double.parseDouble(String.valueOf(insMap.get("pcr"))));
    					}catch(Exception ex){
    						charge = charge + (reqqty * (double)insMap.get("itmprc") * Double.parseDouble(String.valueOf(insMap.get("pcr"))));
    					}

    					try{
    						incharge = incharge + (reqqty * (int)insMap.get("itmprc"));
    					}catch(Exception ex){
    						incharge = incharge + (reqqty * (double)insMap.get("itmprc"));
    					}

    				}
    			}
    			invoiceD.put("itemtype", 1272);
    			invoiceD.put("itemordno", "");
    			invoiceD.put("pstpo", insMap.get("pstpo"));
    			invoiceD.put("itmcd", insMap.get("itmcd"));
    			invoiceD.put("itmnm1", insMap.get("itmnm"));
    			invoiceD.put("itmnm2", "");
    			invoiceD.put("serialno", "");
    			invoiceD.put("reqqty", insMap.get("reqqty"));
    			invoiceD.put("itmprc", insMap.get("itmprc"));

    			//logger.debug(" :::??????요청수량?????????? {} ", insMap.get("reqqty"));

    			invoiceList.add(invoiceD);
    			//logger.debug(" :::??????hamTestttttttttttttttt??????? {} ", invoiceList.get(i));
			}
		}

		//2577 , 2579
		int zreexptid = 0;
		try{
			zreexptid = pst.getZrExportationIDByPOSID(psoid);
		}catch(Exception ex){
			zreexptid = 0;
		}
		int taxcodeid = 0;
		int taxrate   = 0;
		if (zreexptid != 0 )
        {
			taxcodeid = 38;//TaxCodeID = 38; //ZE
			taxrate   = 0;//TaxRate = 0;
        }
        else
        {
        	taxcodeid = 32;//TaxCodeID = 32; //SR
        	taxrate   = 0;//TaxRate = 6;
        }

		ordMap.put("userid", userId);

		if (psttype == 2577 || 2579 == psttype){
			double taxed = 0.0;
			if (taxrate > 0){
				taxed = charge * taxrate;
			}
			int docno = 129;
			String invoiceno    = pst.invoiceDocNoSelect(docno);

			taxed = incharge*0.00;

			//ordMap.put("schaount", charge + taxed);
			ordMap.put("schaount", incharge + taxed);
			//ordMap.put("billnet", taxed);
			ordMap.put("billnet", taxed);
			ordMap.put("taxrate", taxrate);
			ordMap.put("taxcodeid", taxcodeid);
			ordMap.put("invoiceno", invoiceno);
			if (pstinvtype == 5708){
				wholesale = 1271;
				ordMap.put("invtype", wholesale);
			}
			else{
				compensation = 5704;
				ordMap.put("invtype", compensation);
			}

			//orderbill
			pst.BillOrderInsert(ordMap);
			//invoiceM
			taxed = incharge*0.00;
			ordMap.put("billnet", taxed);
			ordMap.put("charges", incharge);
			ordMap.put("ammount", incharge+taxed);//dddd

			ordMap.put("reqstno", reqstSeq);

			if (pstinvtype == 5708){
				wholesale = 123;
				ordMap.put("invtype", wholesale);
			}
			else{
				compensation = 440;
				ordMap.put("invtype", compensation);
			}

			Map<String , Object> addMap = pst.selectDealerAddressMasic((int)ordMap.get("dealerid"));
			String invoicetaxid = pst.selectinvoiceTaxId();
			ordMap.put("invoicetaxid", invoicetaxid);
			if (addMap == null){
				ordMap.put("addr1", "");
				ordMap.put("addr2", "");
				ordMap.put("addr3", "");
				ordMap.put("addr4", "");
				ordMap.put("post" , "");
				ordMap.put("state", "");
				ordMap.put("cnty" , "");

			}else{
				/**ordMap.put("addr1", addMap.get("CITY"));
				ordMap.put("addr2", addMap.get("AREA"));
				ordMap.put("addr3", addMap.get("ADDR_DTL"));
				ordMap.put("addr4", "");**/

				// Edited for rearranging address layout in billing invoice. By Hui Ding, 01/11/2019
				ordMap.put("addr1", addMap.get("ADDR_DTL"));
				ordMap.put("addr2", addMap.get("STREET"));
				ordMap.put("addr3",  addMap.get("AREA"));
				ordMap.put("addr4",  addMap.get("CITY"));
				ordMap.put("areaId", addMap.get("AREA_ID"));
				ordMap.put("post" , addMap.get("POSTCODE"));
				ordMap.put("state", addMap.get("STATE"));
				ordMap.put("cnty" , addMap.get("COUNTRY"));
			}

			logger.debug(" reqstno %%%%%%%%%%% {} ", ordMap.get("reqstno"));

			pst.InvoiceMListInsert(ordMap);
			//invoiceD
			for (int i = 0 ; i < invoiceList.size(); i++){
			//	logger.debug(" :::******invoiceList******** {} ", invoiceList.get(i));
				Map<String , Object> indmap = (Map<String, Object>)invoiceList.get(i);
				String invoiceoitmid = pst.selectinvoiceItemId();
				if (taxrate > 0){
					indmap.put("gstrate", taxrate);
				}else{
					indmap.put("gstrate", 0);
				}
				indmap.put("taxinvoidid" , invoicetaxid);
				indmap.put("invoiceitmid", invoiceoitmid);

				if (pstinvtype == 5708){
					wholesale = 1272;
					indmap.put("itemtype", wholesale);
				}
				else{
					compensation = 5703;
					indmap.put("itemtype", compensation);
				}
				logger.debug(" :::!!!!!???? {} ", indmap);
				pst.InvoiceDListInsert(indmap);
			}

		}
	}
}
