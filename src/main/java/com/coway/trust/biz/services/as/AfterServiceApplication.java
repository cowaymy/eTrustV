package com.coway.trust.biz.services.as;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.type.FileType;

public interface AfterServiceApplication {

  void insertAfterServiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params, List<String> seqs);

  void updateAfterServiceAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params,List<String> seqs);

}