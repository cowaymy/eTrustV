/**
 *
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.stocks.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.impl.CommonServiceImpl;
import com.coway.trust.biz.logistics.stocks.StockService;
import com.coway.trust.cmmn.exception.ApplicationException;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("stockService")
public class StockServiceImpl extends EgovAbstractServiceImpl implements StockService {

	private static final Logger logger = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Resource(name = "stockMapper")
	private StockMapper stockMapper;

	@Override
	public List<EgovMap> selectStockList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockList(params);
	}

	@Override
	public List<EgovMap> selectStockInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockInfo(params);
	}

	@Override
	public List<EgovMap> selectPriceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceInfo(params);

	}

	@Override
	public List<EgovMap> selectFilterInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectFilterInfo(params);
	}

	@Override
	public List<EgovMap> selectServiceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectServiceInfo(params);
	}

	@Override
	public List<EgovMap> selectStockImgList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockImgList(params);
	}

	@Override
	public void updateStockInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		stockMapper.updateStockInfo(params);

		String apptype_id = "";
		if (params.get("stock_type") != null && "61".equals(params.get("stock_type"))) {
			params.put("app_type_id", "66");
			stockMapper.updateSalePriceUOM(params);
			params.put("app_type_id", "67");
			stockMapper.updateSalePriceUOM(params);
		} else {
			params.put("app_type_id", "69");
			stockMapper.updateSalePriceUOM(params);
		}
	}

	@Override
	public void updateStockPriceInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub

		stockMapper.updateStockPriceInfo(params);

	}


	@Override
	public void modifyServicePoint(Map<String, Object> params) {
		// TODO Auto-generated method stub
		stockMapper.modifyServicePoint(params);
	}

	@Override
	public void updatePriceInfo(Map<String, Object> params) {
    logger.debug("[updatePriceInfo] START ");
    // TODO Auto-generated method stub
    Map<String, Object> smap = new HashMap<>();
    Map<String, Object> smap2 = new HashMap<>();

    boolean isEmptyPriceInfo = false;

    smap.put("srvpacid", params.get("srvPackageId"));
    smap2.put("srvpacid", params.get("srvPackageId"));

    smap.put("typeId", params.get("priceTypeid"));
    smap2.put("typeId", params.get("priceTypeid"));


    smap.put("crtUserId", params.get("upd_user"));
    smap2.put("crtUserId", params.get("upd_user"));

    smap.put("upd_user", params.get("upd_user"));
    smap2.put("upd_user", params.get("upd_user"));



    if (params.get("priceTypeid") != null) {

      if ("61".equals(params.get("priceTypeid"))) {
        //outright or outright plus package
        smap.put("stockId", params.get("stockId"));
        smap.put("amt", params.get("dNormalPrice"));
        smap.put("apptypeid", "67");
        smap.put("pricecharges", 0);
        smap.put("pricecosting", params.get("dCost"));
        smap.put("statuscodeid", 1);
        smap.put("pricepv", params.get("dPV"));
        smap.put("tradeinpv", params.get("dTradeInPV"));
        smap.put("srvpacid", params.get("srvPackageId"));
        smap.put("pricerpf", params.get("dRentalDeposit"));

        //rental package
        smap2.put("stockId", params.get("stockId"));
        smap2.put("amt", params.get("dMonthlyRental"));
        smap2.put("apptypeid", "66");
        smap2.put("pricecharges", 0);
        smap2.put("pricecosting", params.get("dCost"));
        smap2.put("statuscodeid", 1);
        smap2.put("pricepv", params.get("dPV"));
        smap2.put("tradeinpv", params.get("dTradeInPV"));
        smap2.put("pricerpf", params.get("dRentalDeposit"));
        smap2.put("srvpacid", params.get("srvPackageId"));

       List<EgovMap> info = stockMapper.selectPriceInfo(smap);

       String pricecost, amt ,pricepv, mrental, pricerpf, penalty, tradeinpv;

       if (info != null || !info.isEmpty()){
           for(Object obj: info){
               pricecost = (String) ((Map<String, Object>) obj).get("pricecost").toString();
               amt = (String) ((Map<String, Object>) obj).get("amt").toString();
               pricepv = (String) ((Map<String, Object>) obj).get("pricepv").toString();
               mrental = (String) ((Map<String, Object>) obj).get("mrental").toString();
               pricerpf = (String) ((Map<String, Object>) obj).get("pricerpf").toString();
               penalty = (String) ((Map<String, Object>) obj).get("penalty").toString();
               tradeinpv = (String) ((Map<String, Object>) obj).get("tradeinpv").toString();

               if(pricecost.equals("0") && amt.equals("0") && pricepv.equals("0") && mrental.equals("0") && pricerpf.equals("0") && penalty.equals("0") && tradeinpv.equals("0")){
                    int pac_id = stockMapper.selectPacId();
                    smap.put("pac_id", pac_id);
                    smap2.put("pac_id", pac_id+1);
                    isEmptyPriceInfo = true;
               }
           }
        }

         stockMapper.insertSalePriceInfoHistory(smap);
         stockMapper.insertSalePriceInfoHistory(smap2);

        if(isEmptyPriceInfo == false){
          stockMapper.updateSalePriceInfo(smap);
          stockMapper.updateSalePriceInfo(smap2);
        }else{
          stockMapper.insertSalePriceInfo(smap);
          stockMapper.insertSalePriceInfo(smap2);
        }
    } else {
        smap.put("priceTypeid", params.get("priceTypeid"));
        smap.put("stockId", params.get("stockId"));
        smap.put("amt", params.get("dNormalPrice"));
        smap.put("apptypeid", params.get("appTypeId"));
        smap.put("pricecharges", params.get("dPenaltyCharge"));
        smap.put("pricecosting", params.get("dCost"));
        smap.put("statuscodeid", 1);

        stockMapper.insertSalePriceInfoHistory(smap);

        if(isEmptyPriceInfo == false){
            stockMapper.updateSalePriceInfo(smap);
        }else{
            stockMapper.insertSalePriceInfo(smap);
        }
      }
    }
    logger.debug("[updatePriceInfo] END ");
  }


	@Override
	public List<EgovMap> srvMembershipList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.srvMembershipList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public int addServiceInfoGrid(int stockId, List<Object> addLIst, int loginId) {
		int cnt = 0;

		int pac_id = stockMapper.selectPacId();
		logger.debug("pac_id : {}", pac_id);
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("pac_id", pac_id);
		for (Object obj : addLIst) {
			param.put("packagename", ((Map<String, Object>) obj).get("packagename"));
			param.put("chargeamt", (((Map<String, Object>) obj).get("chargeamt") == null) ? 0
					: ((Map<String, Object>) obj).get("chargeamt"));
			cnt = cnt + stockMapper.addServiceInfoGrid(param);
		}

		logger.debug("stockId : {}", param.get("stockId"));
		logger.debug("crtUserId : {}", param.get("crtUserId"));
		logger.debug("packagename : {}", param.get("packagename"));
		// TODO Auto-generated method stub
		return cnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int removeServiceInfoGrid(int stockId, List<Object> removeLIst, int loginId) {
		// TODO Auto-generated method stub
		int cnt = 0;
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		for (Object obj : removeLIst) {
			param.put("packageid", ((Map<String, Object>) obj).get("packageid"));
			cnt = cnt + stockMapper.removeServiceInfoGrid(param);
		}
		return cnt;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int removeFilterInfoGrid(int stockId, List<Object> removeLIst, int loginId, String revalue) {
		int cnt = 0;

		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("revalue", revalue);
		for (Object obj : removeLIst) {
			param.put("bom_part_id", ((Map<String, Object>) obj).get("stockid"));
			// String bom_part_id = (String) ((Map<String, Object>) obj).get("typeid");
			// param.put("bom_part_id", Integer.parseInt(bom_part_id));
			cnt = cnt + stockMapper.removeFilterInfoGrid(param);
		}
		return cnt;
	}

	@SuppressWarnings({ "unchecked", "null" })
	@Override
	public int addFilterInfoGrid(int stockId, List<Object> addLIst, int loginId, String revalue) {
		int cnt = 0;

		int bom_id = stockMapper.selectBomId();
		logger.debug("bom_id : {}", bom_id);
		Map<String, Object> param = new HashMap<>();
		param.put("stockId", stockId);
		param.put("crtUserId", loginId);
		param.put("revalue", revalue);
		param.put("bom_id", bom_id);
		if (null != addLIst) {
			for (Object obj : addLIst) {
				String bom_stk_id = (String) ((Map<String, Object>) obj).get("stockid");
				String bom_part_qty = (String) ((Map<String, Object>) obj).get("qty");
				param.put("bom_stk_id", Integer.parseInt(bom_stk_id));
				param.put("bom_part_qty", Integer.parseInt(bom_part_qty));

				if (revalue.equals("filter_info")) {
					String bom_part_id = (String) ((Map<String, Object>) obj).get("typeid");
					String bom_part_priod = (String) ((Map<String, Object>) obj).get("period");
					param.put("bom_part_id", Integer.parseInt(bom_part_id));
					param.put("bom_part_priod", Integer.parseInt(bom_part_priod));
				}

				cnt = cnt + stockMapper.addFilterInfoGrid(param);
			}
		}

		return cnt;
	}

	@Override
	public List<EgovMap> selectPriceHistoryInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceHistoryInfo(params);
	}

	@Override
	public List<EgovMap> selectStockCommisionSetting(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return stockMapper.selectStockCommisionSetting(param);
	}

	@Override
	public void updateStockCommision(Map<String, Object> params) {
		// TODO Auto-generated method stub
		logger.debug("stckcd : {}", params.get("stckcd"));
		stockMapper.updateStockCommision(params);
	}

	@Override
	public String nonvalueStockIns(Map<String, Object> params) {
		// TODO Auto-generated method stub
		String reVal = stockMapper.nonvaluedItemCodeChk(params);
		if ("0".equals(reVal)){

    		int stkid = stockMapper.stockSTKIDsearch();
    		params.put("stkid", stkid);
    		stockMapper.nonvalueStockIns(params);
    		stockMapper.nonvalueItemPriceins(params);
		}
		return reVal;
	}

	@Override
	public EgovMap nonvaluedItemCodeChk(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return null;//stockMapper.nonvaluedItemCodeChk(params);
	}

	@Override
	 public List<EgovMap> selectCodeList(){

	   return stockMapper.selectCodeList();
	 }

	@Override
	public List<EgovMap> getEosEomInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.getEosEomInfo(params);
	}

	@Override
	public void modifyEosEomInfo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		stockMapper.modifyEosEomInfo(params);
	}

	@Override
	 public List<EgovMap> selectCodeList2(){

	   return stockMapper.selectCodeList2();
	 }

	@Override
	public void updatePriceInfo2(Map<String, Object> params) {
    logger.debug("[updatePriceInfo2] START ===== params========" + params);
    // TODO Auto-generated method stub
    Map<String, Object> smap = new HashMap<>();
    Map<String, Object> smap2 = new HashMap<>();

    String msgf = "";
    boolean isEmptyPriceInfo = false;

    smap.put("srvpacid", params.get("srvPackageId"));
    smap2.put("srvpacid", params.get("srvPackageId"));

    smap.put("typeId", params.get("priceTypeid"));
    smap2.put("typeId", params.get("priceTypeid"));


    smap.put("crtUserId", params.get("upd_user"));
    smap2.put("crtUserId", params.get("upd_user"));

    smap.put("upd_user", params.get("upd_user"));
    smap2.put("upd_user", params.get("upd_user"));

    if (params.get("priceTypeid") != null) {
    	if ("61".equals(params.get("priceTypeid").toString())){

        //outright or outright plus package
        smap.put("stockId", params.get("stockId"));
        smap.put("amt", params.get("dNormalPrice"));
        smap.put("appTypeId", "67");
        smap.put("pricecharges", 0);
        smap.put("pricecosting", params.get("dCost"));
        smap.put("statuscodeid", 1);
        smap.put("pricepv", params.get("dPV"));
        smap.put("tradeinpv", params.get("dTradeInPV"));
        smap.put("srvpacid", params.get("srvPackageId"));
        smap.put("pricerpf", params.get("dRentalDeposit"));

        //rental package
        smap2.put("stockId", params.get("stockId"));
        smap2.put("amt", params.get("dMonthlyRental"));
        smap2.put("appTypeId", "66");
        smap2.put("pricecharges", 0);
        smap2.put("pricecosting", params.get("dCost"));
        smap2.put("statuscodeid", 1);
        smap2.put("pricepv", params.get("dPV"));
        smap2.put("tradeinpv", params.get("dTradeInPV"));
        smap2.put("pricerpf", params.get("dRentalDeposit"));
        smap2.put("srvpacid", params.get("srvPackageId"));

        List<EgovMap> info = null;
        if(params.get("appTypeId").toString().equals("66")){
        	info = stockMapper.selectPriceInfo2(smap2);
        }else if(params.get("appTypeId").toString().equals("67")){
        	info = stockMapper.selectPriceInfo2(smap);
        }
        logger.debug("info >>>> " + info);
       String pricecost, amt ,pricepv, mrental, pricerpf, penalty, tradeinpv;

       if (info != null || !info.isEmpty()){
           for(Object obj: info){
               pricecost = (String) ((Map<String, Object>) obj).get("pricecost").toString();
               amt = (String) ((Map<String, Object>) obj).get("amt").toString();
               pricepv = (String) ((Map<String, Object>) obj).get("pricepv").toString();
               mrental = (String) ((Map<String, Object>) obj).get("mrental").toString();
               pricerpf = (String) ((Map<String, Object>) obj).get("pricerpf").toString();
               penalty = (String) ((Map<String, Object>) obj).get("penalty").toString();
               tradeinpv = (String) ((Map<String, Object>) obj).get("tradeinpv").toString();

               if(pricecost.equals("0") && amt.equals("0") && pricepv.equals("0") && mrental.equals("0") && pricerpf.equals("0") && penalty.equals("0") && tradeinpv.equals("0")){
            	   int pac_id = 0;

            	   int sm = stockMapper.chcekCountPacId(smap2);
            	   int sm2 = stockMapper.chcekCountPacId(smap);
            	   logger.debug("sm ====== " + sm);
            	   logger.debug("sm2 ===== " + sm2);
            	   if(params.get("appTypeId").toString().equals("66")){
            		   if( sm == 1){
                		   pac_id = stockMapper.selectExistPacId(smap2);
                	   }else if(sm == 0){
                		   pac_id = stockMapper.selectPacId();
                		   isEmptyPriceInfo = true;
                	   }
                   }else if(params.get("appTypeId").toString().equals("67")){
                	   if( sm2 == 1){
                		   pac_id = stockMapper.selectExistPacId(smap);
                	   }else if(sm2 == 0){
                		   pac_id = stockMapper.selectPacId();
                		   isEmptyPriceInfo = true;
                	   }
                   }
            	   logger.debug("pacid ===== " + pac_id);
                  //  int pac_id = stockMapper.selectPacId();
            	   if(pac_id != 0){
            		   smap.put("pac_id", pac_id);
                       smap2.put("pac_id", pac_id);
            	   }else{
            		  msgf = "Error! Multiple Price ID found for this material under this package.";
            		  throw new ApplicationException("-1",msgf);
            	   }


               }
           }
        }


        if(isEmptyPriceInfo == false){
			if(params.get("appTypeId").toString().equals("66")){
				 stockMapper.updateSalePriceInfo(smap2);
			}else if(params.get("appTypeId").toString().equals("67")){
				stockMapper.updateSalePriceInfo(smap);
			}
        }else{
			if(params.get("appTypeId").toString().equals("66")){
				 stockMapper.insertSalePriceInfo(smap2);
			}else if(params.get("appTypeId").toString().equals("67")){
				stockMapper.insertSalePriceInfo(smap);
			}
        }

		if(params.get("appTypeId").toString().equals("66")){
			stockMapper.insertSalePriceInfoHistory(smap2);
		}else if(params.get("appTypeId").toString().equals("67")){
			stockMapper.insertSalePriceInfoHistory(smap);
		}



    } else {
        smap.put("priceTypeid", params.get("priceTypeid"));
        smap.put("stockId", params.get("stockId"));
        smap.put("amt", params.get("dNormalPrice"));
        smap.put("appTypeId", params.get("appTypeId"));
        smap.put("pricecharges", params.get("dPenaltyCharge"));
        smap.put("pricecosting", params.get("dCost"));
        smap.put("statuscodeid", 1);

        if(isEmptyPriceInfo == false){
            stockMapper.updateSalePriceInfo(smap);
        }else{
            stockMapper.insertSalePriceInfo(smap);
        }

        stockMapper.insertSalePriceInfoHistory(smap);

      }
    }
    logger.debug("[updatePriceInfo2] END ");
  }

	@Override
	public List<EgovMap> selectPriceInfo2(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceInfo2(params);

	}


	@Override
	public List<EgovMap> selectPriceHistoryInfo2(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return stockMapper.selectPriceHistoryInfo2(params);
	}

	@Override
	public int countInPrgrsPrcApproval(Map<String, Object> params) {
		return stockMapper.countInPrgrsPrcApproval(params);
	}

	@Override
	public void insertSalePriceReqst(Map<String, Object> params) {
		// TODO Auto-generated method stub

	    logger.debug("[insertSalePriceReqst] START ===== params========" + params);

		Map<String, Object> smap = new HashMap<>();
		Map<String, Object> smap2 = new HashMap<>();

		smap.put("srvpacid", params.get("srvPackageId"));
		smap2.put("srvpacid", params.get("srvPackageId"));

		smap.put("typeId", params.get("priceTypeid"));
		smap2.put("typeId", params.get("priceTypeid"));

		smap.put("crtUserId", params.get("upd_user"));
		smap2.put("crtUserId", params.get("upd_user"));

		smap.put("chgRemark", params.get("chgRemark"));
		smap2.put("chgRemark", params.get("chgRemark"));

		if (params.get("priceTypeid") != null) {
			if ("61".equals(params.get("priceTypeid").toString())){

		    //outright or outright plus package
		    smap.put("stockId", params.get("stockId"));
		    smap.put("amt", params.get("dNormalPrice"));
		    smap.put("appTypeId", "67");
		    smap.put("pricecharges", 0);
		    smap.put("pricecosting", params.get("dCost"));
		    smap.put("pricepv", params.get("dPV"));
		    smap.put("tradeinpv", params.get("dTradeInPV"));
		    smap.put("srvpacid", params.get("srvPackageId"));
		    smap.put("pricerpf", params.get("dRentalDeposit"));


		    //rental package
		    smap2.put("stockId", params.get("stockId"));
		    smap2.put("amt", params.get("dMonthlyRental"));
		    smap2.put("appTypeId", "66");
		    smap2.put("pricecharges", 0);
		    smap2.put("pricecosting", params.get("dCost"));
		    smap2.put("pricepv", params.get("dPV"));
		    smap2.put("tradeinpv", params.get("dTradeInPV"));
		    smap2.put("pricerpf", params.get("dRentalDeposit"));
		    smap2.put("srvpacid", params.get("srvPackageId"));

		    if(params.get("appTypeId").toString().equals("66")){
		    	stockMapper.insertSalePriceReqst(smap2);
		    	}else if(params.get("appTypeId").toString().equals("67")){
		    		stockMapper.insertSalePriceReqst(smap);
		    		}


		    } else {
		        smap.put("priceTypeid", params.get("priceTypeid"));
		        smap.put("stockId", params.get("stockId"));
		        smap.put("amt", params.get("dNormalPrice"));
		        smap.put("appTypeId", params.get("appTypeId"));
		        smap.put("pricecharges", params.get("dPenaltyCharge"));
		        smap.put("pricecosting", params.get("dCost"));
		        stockMapper.insertSalePriceReqst(smap);

		      }

	    logger.debug("[insertSalePriceReqst] END ===== params========" + params);

		}
	}

	@Override
	public void updatePriceReqstApproval(Map<String, Object> params) {
		// TODO Auto-generated method stub

		stockMapper.updatePriceReqstApproval(params);

	}

}
