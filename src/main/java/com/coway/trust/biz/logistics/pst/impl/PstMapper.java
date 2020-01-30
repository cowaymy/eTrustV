package com.coway.trust.biz.logistics.pst.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("PstMapper")
public interface PstMapper {
	
	String selectPstMovementSeq();
	
	String selectMdnNo();

	List<EgovMap> PstSearchList(Map<String, Object> params);
	
	void pstRequestInsert(Map<String, Object> params);
	
	void pstRequestInsertDetail(Map<String, Object> params);
	
	int insertMovementSerial(Map<String, Object> params);
	
	List<EgovMap> selectRequestData(String param);
	
	void pstMaterialDocumentInsertDetail(Map<String, Object> params);
	
	void pstMaterialDocumentInsert(Map<String, Object> params);
	
	void pstMaterialStockBalance(Map<String, Object> params);
	
	void pstMaterialStockSerialDelete(Map<String, Object> params);
	
	void pstMaterialStockSerialInsert(Map<String, Object> params);
	
	void updatePSTsalesPStDetail(Map<String, Object> params);
	
	void updatePSTsalesMaster(Map<String, Object> params);
	
	void insertPSTsalesPStLog(Map<String, Object> params);
	
	int getZrExportationIDByPOSID(int psoid);
	
	int selectPstSalseDoMasterId();
	
	void insertPSTsalesDOM(Map<String, Object> params);
	
	int selectPstSalseDetailId();
	
	void insertPSTsalesDOMD(Map<String, Object> params);
	
	void updatePSTsalesDetail(Map<String, Object> params);
	
	void insertPSTsalesLog(Map<String, Object> params);
	
	void BillOrderInsert(Map<String, Object> params);
	
	void InvoiceMListInsert(Map<String, Object> params);
	
	void InvoiceDListInsert(Map<String, Object> params);
	
	String invoiceDocNoSelect(int docno);
	
	String selectinvoiceTaxId();
	
	String selectinvoiceItemId();
	
	void insertStockCardList(Map<String, Object> params);
	
	Map<String , Object> selectDealerAddressMasic(int dealerid);
	
	List<EgovMap> PstMaterialDocViewList(Map<String, Object> params);

	List<EgovMap> selectPstIssuePop(Map<String, Object> params); 				// KR OHK : PST Serial Check List

}
