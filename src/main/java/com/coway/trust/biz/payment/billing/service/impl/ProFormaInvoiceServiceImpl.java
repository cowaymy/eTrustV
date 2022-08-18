package com.coway.trust.biz.payment.billing.service.impl;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.payment.billing.service.ProFormaInvoiceService;
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
	  public void saveNewProForma(Map<String, Object> params) {
		 logger.debug("================saveNewProForma - START ================");
		 logger.debug(params.toString());

		 String pfNo = proFormaInvoiceMapper.selectDocNo(DocTypeConstants.PROFORMA_NO); //doc no 188
		 params.put("pfNo",pfNo); //REF_NO

		 proFormaInvoiceMapper.saveNewProForma(params);

	    EgovMap em = new EgovMap();
	    em.put("orderNo", params.get("orderNo"));

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
}
