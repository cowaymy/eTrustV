package com.coway.trust.biz.supplement;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;
import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementTagManagementService {
  List<EgovMap> selectTagManagementList( Map<String, Object> params ) throws Exception;

  List<EgovMap> selectTagStus();

  List<EgovMap> getMainTopicList();

  List<EgovMap> getInchgDeptList();

  List<EgovMap> getSubTopicList( Map<String, Object> params );

  List<EgovMap> getSubDeptList( Map<String, Object> params );

  EgovMap selectOrderBasicInfo( Map<String, Object> params ) throws Exception;

  List<EgovMap> searchOrderBasicInfo( Map<String, Object> params );

  EgovMap selectViewBasicInfo( Map<String, Object> params ) throws Exception;

  List<EgovMap> getResponseLst( Map<String, Object> params ) throws Exception;

  void insertTagSubmissionAttachBiz( List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs );

  Map<String, Object> supplementTagSubmission( Map<String, Object> params ) throws Exception;

  void insertAttachBiz( List<FileVO> list, FileType type, Map<String, Object> params );

  Map<String, Object> updateTagInfo( Map<String, Object> params ) throws Exception;

  List<EgovMap> getAttachListCareline( Map<String, Object> params );

  List<EgovMap> getAttachListHq( Map<String, Object> params );

  void sendEmail( Map<String, Object> params );
}
