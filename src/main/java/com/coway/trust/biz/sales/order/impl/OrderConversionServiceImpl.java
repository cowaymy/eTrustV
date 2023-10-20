package com.coway.trust.biz.sales.order.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.sales.mambership.impl.MembershipRSMapper;
import com.coway.trust.biz.sales.order.OrderConversionService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("orderConversionService")
public class OrderConversionServiceImpl extends EgovAbstractServiceImpl implements  OrderConversionService{

	private static final Logger logger = LoggerFactory.getLogger(OrderConversionServiceImpl.class);

	@Resource(name = "orderConversionMapper")
	private OrderConversionMapper orderConversionMapper;

	@Resource(name = "membershipRSMapper")
	private MembershipRSMapper membershipRSMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	/**
	 * 글 목록을 조회한다.
	 *
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> orderConversionList(Map<String, Object> params) {
		return orderConversionMapper.orderConversionList(params);
	}

	public EgovMap orderConversionView(Map<String, Object> params) {
		return orderConversionMapper.orderConversionView(params);
	}

	public List<EgovMap> orderConversionViewItmList(Map<String, Object> params) {
		return orderConversionMapper.orderConversionViewItmList(params);
	}

	public List<EgovMap> orderCnvrValidItmList(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrValidItmList(params);
	}

	public List<EgovMap> orderCnvrInvalidItmList(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrInvalidItmList(params);
	}

	public void delCnvrItmSAL0073D(Map<String, Object> params) {
		orderConversionMapper.delCnvrItmSAL0073D(params);
	}

	public void updCnvrConfirm(Map<String, Object> params) {
		orderConversionMapper.updCnvrConfirm(params);
	}

	public void updCnvrDeactive(Map<String, Object> params) {
		orderConversionMapper.updCnvrDeactive(params);
	}

	public EgovMap orderCnvrInfo(Map<String, Object> params) {
		return orderConversionMapper.orderCnvrInfo(params);
	}

	@Override
	public List<EgovMap> chkNewCnvrList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		EgovMap result = new EgovMap();

		String msg = null;

		Map<String, Object> map = new HashMap();

		List checkList = new ArrayList();

		for (Object obj : list)
		{
			((Map<String, Object>) obj).put("userId", params.get("userId"));

			logger.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			params.put("ordNo", ((Map<String, Object>) obj).get("0"));

			if(!StringUtils.isEmpty(params.get("ordNo"))){
				((Map<String, Object>) obj).put("ordNo",  String.format("%07d", Integer.parseInt(((Map<String, Object>) obj).get("0").toString())));

				EgovMap info = orderConversionMapper.orderCnvrInfo(params);

				((Map<String, Object>) obj).put("orderNo", info.get("ordNo"));
				((Map<String, Object>) obj).put("ordStusCode", info.get("ordStusCode"));
				((Map<String, Object>) obj).put("appTypeCode", info.get("appTypeCode"));
				((Map<String, Object>) obj).put("rentalStus", info.get("rentalStus"));
				logger.debug("info ================>>  " + info.get("ordNo"));
				logger.debug("info ================>>  " + info.get("ordStusCode"));
				logger.debug("info ================>>  " + info.get("appTypeCode"));
				logger.debug("info ================>>  " + info.get("rentalStus"));
				checkList.add(obj);
				continue;
			}
		}
		return checkList;
	}

	public void saveNewConvertList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		logger.debug("gridData ============>> " + list);

		params.put("docNoId", 100);
		String convertNo = membershipRSMapper.getDocNo(params);

		int crtSeqSAL0072D = orderConversionMapper.crtSeqSAL0072D();
		params.put("rsCnvrId", crtSeqSAL0072D);
		params.put("stusFrom", formData.get("pRsCnvrStusFrom"));
		params.put("stusTo", formData.get("pRsCnvrStusTo"));
		params.put("rsStusId", 1);
		params.put("rsCnvrStusId", 44);
		params.put("rsCnvrRem", formData.get("newCnvrRem"));
		params.put("rsCnvrCnfmUserId", 0);
		params.put("rsCnvrCnfmDt", SalesConstants.DEFAULT_DATE);
		params.put("rsCnvrUserId", 0);
		params.put("rsCnvrDt", SalesConstants.DEFAULT_DATE);
		params.put("rsCnvrNo", convertNo);
		params.put("rsCnvrAttachUrl", "");
		params.put("rsCnvrReactFeesApply", formData.get("rsCnvrReactFeesApply"));
		params.put("rsCnvrTypeId", 1319);

		orderConversionMapper.insertCnvrSAL0072D(params);

		for (Object obj : list)
		{
			params.put("ordNo",  ((Map<String, Object>) obj).get("ordNo"));
			params.put("rsItmStusId", 1);
			params.put("rsSysSoId", 0);
			params.put("appTypeId", 0);
			params.put("rsSysRentalStus", "");
			params.put("rsItmValidStus", 0);
			params.put("rsItmValidRem", "");
			params.put("rsItmCnvrStusId", 44);
			params.put("rsItmUserId", 0);
			params.put("rsItmCnvrDt", SalesConstants.DEFAULT_DATE);
			params.put("rsItmCntrctId", 0);
			params.put("rsItmCntrctNo", null);
			orderConversionMapper.insertCnvrSAL0073D(params);
		}
		params.put("batchId", crtSeqSAL0072D);
		orderConversionMapper.insertCnvrList(params);
	}

	@Override
	public List<EgovMap> chkPayCnvrList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		EgovMap result = new EgovMap();

		String msg = null;

		Map<String, Object> map = new HashMap();

		List checkList = new ArrayList();

		int convertType = Integer.parseInt(String.valueOf(formData.get("cnvrType")));

		for (Object obj : list)
		{
			((Map<String, Object>) obj).put("userId", params.get("userId"));

			logger.debug(" OrderNo : {}", ((Map<String, Object>) obj).get("0"));
			logger.debug(" Remark : {}", ((Map<String, Object>) obj).get("1"));
			logger.debug(" TokenId : {}", ((Map<String, Object>) obj).get("2"));

			params.put("ordNo", ((Map<String, Object>) obj).get("0"));
			params.put("remark", ((Map<String, Object>) obj).get("1"));
			params.put("tokenId", ((Map<String, Object>) obj).get("2"));

            if(convertType == 1){
			if(!StringUtils.isEmpty(params.get("ordNo"))){
				((Map<String, Object>) obj).put("ordNo",  ((Map<String, Object>) obj).get("0").toString());

				EgovMap info = orderConversionMapper.orderCnvrInfo(params);

				((Map<String, Object>) obj).put("orderNo", info.get("ordNo"));
				((Map<String, Object>) obj).put("orderId", info.get("ordId"));
				((Map<String, Object>) obj).put("reason", ((Map<String, Object>) obj).get("1"));
				((Map<String, Object>) obj).put("payModeId", info.get("code"));
				((Map<String, Object>) obj).put("payModeName", info.get("codeName"));
				((Map<String, Object>) obj).put("tokenId", ((Map<String, Object>) obj).get("2"));
				logger.debug("info ================>>  " + info.get("ordNo"));
				logger.debug("info ================>>  " + info.get("ordId"));
				logger.debug("info ================>>  " + ((Map<String, Object>) obj).get("1"));
				logger.debug("info ================>>  " + ((Map<String, Object>) obj).get("2"));
				checkList.add(obj);
				continue;
			}
            }
            else{
            	if(!StringUtils.isEmpty(params.get("ordNo"))){
            		logger.debug("info ================>>  " + ((Map<String, Object>) obj).get("0").toString());
    				((Map<String, Object>) obj).put("ordNo",  ((Map<String, Object>) obj).get("0").toString());

    				EgovMap info = orderConversionMapper.srvContractCnvrInfo(params);

    				((Map<String, Object>) obj).put("srvCntrctId", info.get("srvCntrctId"));
    				((Map<String, Object>) obj).put("srvCntrctRefNo", info.get("srvCntrctRefNo"));
    				((Map<String, Object>) obj).put("orderId", info.get("srvCntrctOrdId"));
    				((Map<String, Object>) obj).put("reason", ((Map<String, Object>) obj).get("1"));
    				((Map<String, Object>) obj).put("payModeId", info.get("code"));
    				((Map<String, Object>) obj).put("payModeName", info.get("codeName"));
    				logger.debug("info ================>>  " + info.get("srvCntrctId"));
    				logger.debug("info ================>>  " + info.get("srvCntrctRefNo"));
    				logger.debug("info ================>>  " + info.get("srvCntrctOrdId"));
    				logger.debug("info ================>>  " + ((Map<String, Object>) obj).get("1"));
    				checkList.add(obj);
    				continue;
    			}
            }
		}
		return checkList;
	}

public void savePayConvertList(Map<String, Object> params) {

		List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
		Map<String, Object> formData =  (Map<String, Object>) params.get("form");

		logger.debug("gridData ============>> " + list);
		int convertType = Integer.parseInt(String.valueOf(formData.get("cnvrType")));
		int total = Integer.parseInt(String.valueOf(formData.get("hiddenTotal")));
		String convertFrom = String.valueOf(formData.get("payCnvrStusFrom"));
		String convertTo = String.valueOf(formData.get("payCnvrStusTo"));

		params.put("docNoId", 167);
		String convertNo = membershipRSMapper.getDocNo(params);

		int crtSeqSAL0234D = orderConversionMapper.crtSeqSAL0234D();
		params.put("payCnvrId", crtSeqSAL0234D);
		params.put("payCnvrNo", convertNo);
		params.put("payStusId", 1);
		params.put("payCnvrStusId", 4);
		params.put("payStusFrom", formData.get("payCnvrStusFrom"));
		params.put("payStusTo", formData.get("payCnvrStusTo"));
		params.put("totalItm", total);
		params.put("payCnvrRem", formData.get("newCnvrRem"));
		params.put("payCnvrAttachURL", "");
    params.put("isPnp", 0);

		orderConversionMapper.insertCnvrSAL0234D(params);

		for (Object obj : list)
		{
			params.put("tknId",  ((Map<String, Object>) obj).get("tokenId"));
			params.put("ordId",  ((Map<String, Object>) obj).get("orderId"));
			params.put("ordNo",  ((Map<String, Object>) obj).get("orderNo"));
			params.put("cntrctId",  ((Map<String, Object>) obj).get("srvCntrctId"));
			params.put("cntrctNo",  ((Map<String, Object>) obj).get("srvCntrctRefNo"));
			params.put("remark",  ((Map<String, Object>) obj).get("reason"));
			params.put("status", 4);
			params.put("validRem","");

			orderConversionMapper.insertCnvrSAL0235D(params);

			int crtSeqSAL0236D = orderConversionMapper.crtSeqSAL0236D();
			params.put("deductId", crtSeqSAL0236D);

			if(convertType == 1){

				if("CRC".equals(convertFrom)){
					orderConversionMapper.updSAL0001D(params);
					orderConversionMapper.insertDeductSalesCRCSAL0236D(params);
					orderConversionMapper.updSalesCRCSAL0074D(params);

				}
				else if("REG".equals(convertFrom) && "CRC".equals(convertTo)){
					orderConversionMapper.updRegSAL0001D(params);
					orderConversionMapper.insertDeductSalesREGSAL0236D(params);
					orderConversionMapper.updSalesRegCrcSAL0074D(params);
				}
				else if("REG".equals(convertFrom) && "DD".equals(convertTo)){
					orderConversionMapper.updRegSAL0001D(params);
					orderConversionMapper.insertDeductSalesREGSAL0236D(params);
					orderConversionMapper.updSalesRegDdSAL0074D(params);
				}
				else{
					orderConversionMapper.updSAL0001D(params);
					orderConversionMapper.insertDeductSalesDDSAL0236D(params);
					orderConversionMapper.updSalesDDSAL0074D(params);
				}
			}
			else{
				orderConversionMapper.updSAL0077D(params);
				if("CRC".equals(convertFrom)){
					orderConversionMapper.insertDeductSrvCRCSAL0236D(params);
					orderConversionMapper.updSrvCntrctCRCSAL0074D(params);

				}
				else{
					orderConversionMapper.insertDeductSrvDDSAL0236D(params);
					orderConversionMapper.updSrvCntrctDDSAL0074D(params);
				}
			}


		}
	}

public List<EgovMap> paymodeConversionList(Map<String, Object> params) {
	return orderConversionMapper.paymodeConversionList(params);
}

public EgovMap paymodeConversionView(Map<String, Object> params) {
	return orderConversionMapper.paymodeConversionView(params);
}

public List<EgovMap> paymodeConversionViewItmList(Map<String, Object> params) {
	return orderConversionMapper.paymodeConversionViewItmList(params);
}

public List<EgovMap> selectOrdPayCnvrList(Map<String, Object> params) {
	return orderConversionMapper.selectOrdPayCnvrList(params);
}

public int countPaymodeCnvrExcelList(Map<String, Object> params) {
	return orderConversionMapper.countPaymodeCnvrExcelList(params);
}

  @Override
  public List<EgovMap> chkPayCnvrListPnp(Map<String, Object> params) {

    List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
    Map<String, Object> formData =  (Map<String, Object>) params.get("form");

    EgovMap result = new EgovMap();

    String msg = null;

    Map<String, Object> map = new HashMap();

    List checkList = new ArrayList();

    for (Object obj : list)
    {
      Map<String, Object> o = (Map<String, Object>) obj;

      String cardNo = null;
      String validRemark = null;

      o.put("userId", params.get("userId"));

      if(!StringUtils.isEmpty(o.get("0").toString())){

        cardNo = o.get("2").toString();

        o.put("orderNo", o.get("0"));
        o.put("reason", o.get("1"));
        o.put("cardNo", cardNo);

        EgovMap info = orderConversionMapper.pnpOrderCnvrInfo(o);

        if(info != null){
          o.put("orderId", info.get("ordId"));

          if( info.get("modeId").toString().equals(formData.get("payCnvrStusTo").toString()) && info.get("pnprpsCrcNo").toString().equals(cardNo))
            validRemark = "Paymode Unchanged";

        }else{
          validRemark = "Invalid Order Number";
        }

        if( "PNP".equals(formData.get("payCnvrStusTo").toString()) && (!cardNo.matches("^[0-9]{6}[*]{6}[0-9]{4}$") || cardNo.length() != 16) ){
          validRemark = "Invalid Card Number";
        }

        o.put("validRemark", validRemark);

        checkList.add(o);
      }
    }
    return checkList;
  }

  public void savePayConvertListPnp(Map<String, Object> params) {

    List<Object> list = (List<Object>) params.get(AppConstants.AUIGRID_ALL);
    Map<String, Object> formData =  (Map<String, Object>) params.get("form");

    int total = list.size();
    String convertFrom = String.valueOf(formData.get("payCnvrStusFrom"));
    String convertTo = String.valueOf(formData.get("payCnvrStusTo"));

    params.put("docNoId", 167);
    String convertNo = membershipRSMapper.getDocNo(params);

    int crtSeqSAL0234D = orderConversionMapper.crtSeqSAL0234D();
    params.put("payCnvrId", crtSeqSAL0234D);
    params.put("payCnvrNo", convertNo);
    params.put("payStusId", 1);
    params.put("payCnvrStusId", 4);
    params.put("payStusFrom", formData.get("payCnvrStusFrom"));
    params.put("payStusTo", formData.get("payCnvrStusTo"));
    params.put("totalItm", total);
    params.put("payCnvrRem", formData.get("newCnvrRem"));
    params.put("payCnvrAttachURL", "");
    params.put("isPnp", formData.get("hiddenIsPnp"));

    orderConversionMapper.insertCnvrSAL0234D(params);

    for (Object obj : list)
    {
      Map<String, Object> o = (Map<String, Object>) obj;

      int status  = o.get("validRemark") != null ? 6 : 4;
      int modeId  = params.get("payStusTo").toString().equals("PNP") ? 135 : 130 ;

      params.put("tknId",     o.get("cardNo"));
      params.put("ordId",     o.get("orderId"));
      params.put("ordNo",     o.get("orderNo"));
      params.put("cntrctId",  0);
      params.put("cntrctNo",  0);
      params.put("remark",    o.get("reason"));
      params.put("validRemark",  o.get("validRemark"));
      params.put("status", status);
      params.put("modeId", modeId);

      orderConversionMapper.insertCnvrSAL0235D(params);

      if(status == 4){
        orderConversionMapper.updSAL0001D(params);
        orderConversionMapper.updSalesSAL0074D(params);
      }

    }
  }

}
