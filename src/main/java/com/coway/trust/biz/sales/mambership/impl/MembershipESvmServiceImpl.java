package com.coway.trust.biz.sales.mambership.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.mambership.MembershipESvmService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("membershipESvmService")
public class MembershipESvmServiceImpl extends EgovAbstractServiceImpl implements MembershipESvmService {

	@Resource(name = "membershipESvmMapper")
	private MembershipESvmMapper membershipESvmMapper;

	@Resource(name = "membershipConvSaleMapper")
	private MembershipConvSaleMapper membershipConvSaleMapper;

	private static Logger logger = LoggerFactory.getLogger(MembershipConvSaleServiceImpl.class);
	@Override
	public List<EgovMap> selectESvmListAjax(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmListAjax(params);
	}

	@Override
	public EgovMap selectESvmInfo(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmInfo(params);
	}

	@Override
	public EgovMap selectMemberByMemberID(Map<String, Object> params) {
		return membershipESvmMapper.selectMemberByMemberID(params);
	}

	@Override
	public List<EgovMap> getESvmAttachList(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmAttachList(params);
	}

	@Override
	public List<EgovMap> selectActionOption(Map<String, Object> params) {
		return membershipESvmMapper.selectActionOption(params);
	}

	@Override
	public List<EgovMap> selectCardMode(Map<String, Object> params) {
		return membershipESvmMapper.selectCardMode(params);
	}

	@Override
	public List<EgovMap> selectIssuedBank(Map<String, Object> params) {
		return membershipESvmMapper.selectIssuedBank(params);
	}

	@Override
	public List<EgovMap> selectCardType(Map<String, Object> params) {
		return membershipESvmMapper.selectCardType(params);
	}

	@Override
	public List<EgovMap> selectMerchantBank(Map<String, Object> params) {
		return membershipESvmMapper.selectMerchantBank(params);
	}

	@Override
	public EgovMap selectESvmPreSalesInfo(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmPreSalesInfo(params);
	}

	@Override
	public EgovMap selectESvmPaymentInfo(Map<String, Object> params) {
		return membershipESvmMapper.selectESvmPaymentInfo(params);
	}

	@Override
	public String selectDocNo(Map<String, Object> params) {
		return membershipESvmMapper.getDocNo(params);
	}

	@Override
	public EgovMap selectMembershipQuotInfo(Map<String, Object> params) {
		return membershipESvmMapper.selectMembershipQuotInfo(params);
	}

	@Override
	public void updateAction(Map<String, Object> params) {
		membershipESvmMapper.updateAction(params);
		membershipESvmMapper.updateTR(params);
	}

	@Override
	public void updateTR(Map<String, Object> params) {
		membershipESvmMapper.updateTR(params);
	}

	@Override
	public String SAL0095D_insert(Map<String, Object> params) {

		boolean   hasBill =false;
		EgovMap   sal0001dData=null;
		EgovMap   sal0090dData=null;
		EgovMap   sal0093dData=null;
		EgovMap   hasbillMap_PAY0024D=null;
		String 	   memNo ="";
		String  	   memBillNo ="";
		String 	   trType="";

		int o =-1;

		 //채번
		 String  srvMemId = String.valueOf(membershipESvmMapper.getSAL0095D_SEQ(params).get("seq"));
		 params.put("srvMemId", srvMemId);


		hasbillMap_PAY0024D =membershipConvSaleMapper.getHasBill(params); //using srvMemQuoID

		if( null != hasbillMap_PAY0024D ){
			 hasBill =true;
		}


		logger.debug("hasBill  =========== ==>");
		logger.debug("hasBil ,{}" +hasBill);
		logger.debug("hasBill  =========== ==>");


		//GET sal0093dData
		sal0093dData = membershipConvSaleMapper.getSAL0093D_Data(params); //using srvMemQuotId


		if(hasBill == false){

			 params.put("DOCNO","12");
			 memNo =  String.valueOf(membershipESvmMapper.getDocNo(params));

			 params.put("DOCNO","19");
			 memBillNo  = String.valueOf(membershipESvmMapper.getDocNo(params));

			 params.put("srvMemNo", memNo);
			 params.put("srvMemBillNo", memBillNo);

				logger.debug("=================srvMemNo  =========== ==>");
				logger.debug("srvMemNo==>" +memNo);
				logger.debug("srvMemBillNo==>" + memBillNo);
				logger.debug("hasBill  =================================>");


			 /////////////////////////////////////////////////////
			 //master
		     params.put("srvMemQuotId",  String.valueOf(sal0093dData.get("srvMemQuotId")));
		     params.put("srvMemSalesMemId",  String.valueOf(sal0093dData.get("srvSalesMemId")));
			 o = membershipESvmMapper.SAL0095D_insert(params) ;
			/////////////////////////////////////////////////////


			logger.debug("=================SAL0095D_insert  =========== ==>");
			logger.debug("["+	o+"]");
			logger.debug("hasBill  =================================>");


		 }

		 sal0001dData = membershipConvSaleMapper.getSAL0001D_Data(params); //using srvSalesOrdId
		 sal0090dData = membershipConvSaleMapper.getSAL0090D_Data(params); //using srvSalesOrdId


		 if( null != sal0090dData ){

			 Map<String , Object> sal0088dDataMap = new HashMap<String , Object> ();
			 sal0088dDataMap.put ("srvConfigId" , sal0090dData.get("srvConfigId"));
			 sal0088dDataMap.put("srvMbrshId" , srvMemId);
			 sal0088dDataMap.put ("srvPrdStartDt",  "01/01/1900");
			 sal0088dDataMap.put ("srvPrdExprDt","01/01/1900");
			 sal0088dDataMap.put("srvPrdDur",params.get("srvFreq"));
			 sal0088dDataMap.put("srvPrdStusId",  "1");
			 sal0088dDataMap.put ("srvPrdRem", "");
			 sal0088dDataMap.put ("srvPrdCrtDt",  new Date());
			 sal0088dDataMap.put ("srvPrdCrtUserId",  params.get("userId"));
			 sal0088dDataMap.put("srvPrdUpdDt", new Date());


			logger.debug("sal0088dDataMap  ==>"+sal0088dDataMap.toString());
			int  s88dCnt  = membershipConvSaleMapper.SAL0088D_insert(sal0088dDataMap); //need to check if need to call
			logger.debug("s88dCnt  ==>"+s88dCnt);

			logger.debug("params  ==>"+params.toString());
			 int s90upDataCnt =membershipConvSaleMapper.update_SAL0090D_Stus(params); // need to check if need to call
			logger.debug("s90upDataCnt  ==>"+s90upDataCnt);

		 }


		 if(null !=sal0093dData ){

			 Map<String , Object> sal0093dDataMap = new HashMap<String , Object> ();
			 sal0093dDataMap.put ("srvMemId" , srvMemId);
			 sal0093dDataMap.put ("srvMemQuotID" , sal0093dData.get("srvMemQuotId"));

			 logger.debug("sal0093dDataMap  ==>"+sal0093dDataMap.toString());
			 int  s93upDataCnt =membershipConvSaleMapper.update_SAL0093D_Stus(sal0093dDataMap);
		     logger.debug("s93upDataCnt  ==>"+s93upDataCnt);
		 }

		 /////////////processBills///////////////////
		 //this.processBills(hasBill , params  , sal0093dData);
		 /////////////processBills///////////////////


		 return memNo;

	}
}
