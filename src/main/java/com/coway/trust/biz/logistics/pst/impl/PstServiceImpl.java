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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pstService")
public class PstServiceImpl extends EgovAbstractServiceImpl implements PstService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "PstMapper")
	private PstMapper pst;
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
			Map<String, Object> mainMap = new HashMap();
			String tmpPstid = "";
			boolean bool = true;
			for (int i = 0 ; i < checkList.size(); i++){
				Map<String, Object> tmp = (Map<String, Object>) checkList.get(i);//.get("item");
				int iCnt = 0;
				insMap = (Map<String, Object>)tmp.get("item");
				
				String movtype = "";
				if ((int)insMap.get("psttypeid")==2577){
					movtype = "OD17";
				}else if((int)insMap.get("psttypeid")==2578){
					movtype = "OD18";
				}else if((int)insMap.get("psttypeid")==2579){
					movtype = "OD19";
				}else{
					movtype = "OD20";
				}
				insMap.put("movetype" , movtype);
				insMap.put("userid"   , userId);
				insMap.put("htext", formMap.get("doctext"));
				if (!tmpPstid.equals((String)insMap.get("psono"))){
					reqstSeq = pst.selectPstMovementSeq(); // 요청번호 채번
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
				
				totalPrice = totalPrice+(Integer.parseInt((String)insMap.get("reqqty")) * (int)insMap.get("itmprc"));
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
		
		Map<String , Object> ordMap = new HashMap();
		ordMap.put("reqstno", reqstSeq);
		Map<String , Object> invoiceD = new HashMap();
		ordMap.put("reqstno", reqstSeq);
		int psoid = 0;
		for (int i = 0 ; i < checkList.size(); i++){
			Map<String, Object> tmp = (Map<String, Object>) checkList.get(i);//.get("item");
			int iCnt = 0;
			insMap  = (Map<String, Object>)tmp.get("item");
			psoid   = (int)insMap.get("psoid");
			psttype = (int)insMap.get("psttypeid");
			reqqty  = Integer.parseInt((String)insMap.get("reqqty"));
			ordMap  = insMap;
			if (psttype == 2577 || 2579 == psttype){
				if (reqqty > 0 ){
					charge = charge + (reqqty * (int)insMap.get("itmprc") * Double.parseDouble(String.valueOf(insMap.get("pcr")))); 
					incharge = incharge + (reqqty * (int)insMap.get("itmprc"));
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
			
			invoiceList.add(invoiceD);
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
        	taxrate   = 6;//TaxRate = 6;
            
        }
		
		
		ordMap.put("userid", userId);
		
		if (psttype == 2577 || 2579 == psttype){
			double taxed = 0.0;
			if (taxrate > 0){
				taxed = charge * taxrate;
			}
			int docno = 129;
			String invoiceno    = pst.invoiceDocNoSelect(docno);
			
			ordMap.put("schaount", charge + taxed);
			ordMap.put("billnet", taxed);
			ordMap.put("taxrate", taxrate);
			ordMap.put("taxcodeid", taxcodeid);
			ordMap.put("invoiceno", invoiceno);
			
			//orderbill
			pst.BillOrderInsert(ordMap);
			//invoiceM
			taxed = incharge*0.06;
			ordMap.put("billnet", taxed);
			ordMap.put("charges", incharge);
			ordMap.put("ammount", incharge+taxed);
			
			
			String invoicetaxid = pst.selectinvoiceTaxId();
			ordMap.put("invoicetaxid", invoicetaxid);
			pst.InvoiceMListInsert(ordMap);
			//invoiceD
			for (int i = 0 ; i < invoiceList.size(); i++){
				Map<String , Object> indmap = (Map)invoiceList.get(i);
				logger.debug(" ::: {}" , indmap );
				
				if (taxrate > 0){
					indmap.put("gstrate", taxrate);
				}else{
					indmap.put("gstrate", 0);
				}
				indmap.put("taxinvoidid", invoicetaxid);
				indmap.put("invoicetaxid", invoicetaxid);
				pst.InvoiceDListInsert(indmap);
			}
			
		}
	}
	
	
	
	public String pstRequestMainInsert(Map<String, Object> params) {
		String reqstSeq = pst.selectPstMovementSeq(); // 요청번호 채번
		
		return reqstSeq;
	}
	
	public void testsample(){
		String reqstSeq = "PST17122100001";
		String mdnNo = pst.selectMdnNo();
		List<EgovMap> reqlist = pst.selectRequestData(reqstSeq);
		int psoid = 99999999;
		logger.debug(" ::::: " + mdnNo);
		
		for (int i = 0 ; i < reqlist.size() ; i++){
			Map<String, Object> stmp = (Map<String, Object>)reqlist.get(i);
			logger.debug(" ::::: {} " , stmp);
			//{TRNSTYPEDTL=OD18, REFDOCNO=PSO0000140, REQQTY=1, LOCID=1005, TRNSTYPE=OD, REQCRTDT=20171206, ITMNM=AP-1004AH (ACE), ITMCD=100928, 
			// PFRQN=M, DEBIT=S, UOM=71, REQNOITM=1, CMVT=1, ITMCATEID=55, REQNO=PST17122100001, REQEDDT=20171221, ITMTYPEID=61} 
			//{TRNSTYPEDTL=OD18, REFDOCNO=PSO0000140, REQQTY=1, frlocid=1005, TRNSTYPE=OD, REQCRTDT=20171206, ITMNM=(N.C.V.) BA08-AE, ITMCD=100389, 
			//PFRQN=M, DEBIT=S, UOM=71, REQNOITM=2, CMVT=1, ITMCATEID=56, REQNO=PST17122100001, REQEDDT=20171221, ITMTYPEID=61}
			stmp.put("mdnno", mdnNo);
			stmp.put("psoid", String.valueOf(psoid));
			stmp.put("headtext" , "1111");
			stmp.put("userid" , 184);
			if (i == 0){
				pst.pstMaterialDocumentInsert(stmp);
			}
			
			pst.pstMaterialDocumentInsertDetail(stmp);
			
			pst.pstMaterialStockBalance(stmp);
			
			if ("S".equals(((String)stmp.get("DEBIT")))){
				pst.pstMaterialStockSerialInsert(stmp);
			}else{
				pst.pstMaterialStockSerialDelete(stmp);
			}
		}
	}

	
}
