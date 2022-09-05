package com.coway.trust.biz.payment.billing.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billing.service.ProFormaInvoiceService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.common.DocTypeConstants;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


@Service("proFormaInvoiceService")
public class ProFormaInvoiceServiceImpl extends EgovAbstractServiceImpl implements ProFormaInvoiceService {

	private static final Logger logger = LoggerFactory.getLogger(ProFormaInvoiceServiceImpl.class);

	@Resource(name = "proFormaInvoiceMapper")
	private ProFormaInvoiceMapper proFormaInvoiceMapper;

	@Override
	public List<EgovMap> searchProFormaInvoiceList(Map<String, Object> params) {
		return proFormaInvoiceMapper.searchProFormaInvoiceList(params);
	}

	@Override
	public List<EgovMap> chkCustType(Map<String, Object> params) {
		return proFormaInvoiceMapper.chkCustType(params);
	}

	@Override
	  public void saveNewProForma(List<Object> formList, List<Object> pfList, SessionVO sessionVO) {
		 logger.debug("================saveNewProForma - START ================");
	     Map<String, Object> formMap = (Map<String, Object>)formList.get(0);
	     Map<String, Object> pfMap = new HashMap<String, Object>();
	     String pfNo = proFormaInvoiceMapper.selectDocNo(DocTypeConstants.PROFORMA_NO); //doc no 188
		 pfMap.put("pfNo",pfNo); //REF_NO
		 int pfGroupID = proFormaInvoiceMapper.selectPFGroupID(); //doc no 188
		 pfMap.put("pfGroupID",pfGroupID); //REF_NO

		 //PAY0334D_PRO_FORMA_GRP_ID_SEQ

	     if(pfList.size() > 0){
	    	 Map<String, Object> pf = null;

	    		for (int i=0; i< pfList.size() ; i++) {
	    			pf = (HashMap) pfList.get(i);

	    			pfMap.put("salesOrdId", String.valueOf(pf.get("salesOrdId")));
	    			pfMap.put("packType",formMap.get("packType"));
	    			pfMap.put("memCode",formMap.get("memCode"));
	    			pfMap.put("adStartDt",formMap.get("adStartDt"));
	    			pfMap.put("adEndDt",formMap.get("adEndDt"));
	    			pfMap.put("totalAmt",formMap.get("totalAmt"));
	    			pfMap.put("packPrice",formMap.get("packPrice"));
	    			pfMap.put("remark",formMap.get("remark"));
	    			pfMap.put("discount",formMap.get("discount"));
	    			pfMap.put("stus","1"); //new pro forma = Active
	    			pfMap.put("creator", sessionVO.getUserId());

	    			proFormaInvoiceMapper.saveNewProForma(pfMap);
	    		}
	     }

		 /*EgovMap em = new EgovMap();
	    em.put("orderNo", params.get("orderNo"));*/
		 logger.debug("================saveNewProForma - END ================");
		 logger.debug(formMap.toString());
		 logger.debug(pfMap.toString());
	     logger.debug("================saveNewProForma - END ================");
	  }

	@Override
	  public void farCheckConvertFn(Map<String, Object> params) {
		 logger.debug("================farCheckConvertFn - START ================");
		 logger.debug(params.toString());

		 proFormaInvoiceMapper.farCheckConvertFn(params);

		 logger.debug("================farCheckConvertFn - END ================");
	  }

	@Override
	public List<EgovMap> chkProForma(Map<String, Object> params) {
		return proFormaInvoiceMapper.chkProForma(params);
	}

	@Override
	public List<EgovMap> selectInvoiceBillGroupListProForma(Map<String, Object> params) {
		return proFormaInvoiceMapper.selectInvoiceBillGroupListProForma(params);
	}
}
