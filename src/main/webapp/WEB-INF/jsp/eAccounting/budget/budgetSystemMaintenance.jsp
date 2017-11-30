<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

    // Make AUIGrid 
    var myGridID;
    
    var bYear = "<spring:message code='budget.title.year' />";
    var bMonth = "<spring:message code='budget.title.month' />";
    var bStatus = "<spring:message code='budget.title.status' />";

    // AUIGrid 칼럼 설정
    var columnLayout = [{
        dataField : "budgetYear",
        headerText : '<spring:message code="budget.title.year" />',
        width : 300
    }, {
        dataField : "budgetMonth",
        headerText : '<spring:message code="budget.title.month" />',
        dataType : "date",
        //formatString : "mmm",
        editRenderer : {
            type : "DropDownListRenderer",
            //list: ["1", "2","3","4","5","6","7","8","9","10","11","12"]
            list : ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        },
        width : 300
    }, {
        dataField : "budgetStus",
        headerText : '<spring:message code="budget.title.status" />',
        dataType : "string",
        editRenderer : {
            type : "DropDownListRenderer",
            list : ["Locked", "Open"]
        }
    }];
    
    //Start AUIGrid
    $(document).ready(function() {
        
        // AUIGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, "");
        AUIGrid.bind(myGridID, "addRow", auiAddRowHandler);               // 행 추가 이벤트 바인딩 
            
        //Rule Book Item search
        $("#search").click(function(){  
            var searchDt = $("#searchDt").val();

            Common.ajax("GET", "/eAccounting/budget/selectBudgetSysMaintenanceList", $("#listSForm").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                for(var i = 0; i < result.length; i++) {
                    if(result[i].budgetMonth == 1) {
                        result[i].budgetMonth = 'JAN';
                    } 
                    if(result[i].budgetMonth == 2) {
                        result[i].budgetMonth = 'FEB';      
                    }
                    if(result[i].budgetMonth == 3) {
                        result[i].budgetMonth = 'MAR';
                    }
                    if(result[i].budgetMonth == 4) {
                        result[i].budgetMonth = 'APR';
                    }
                    if(result[i].budgetMonth == 5) {
                        result[i].budgetMonth = 'MAY';
                    }
                    if(result[i].budgetMonth == 6) {
                        result[i].budgetMonth = 'JUN';
                    }
                    if(result[i].budgetMonth == 7) {
                        result[i].budgetMonth = 'JUL';
                    }
                    if(result[i].budgetMonth == 8) {
                        result[i].budgetMonth = 'AUG';
                    }
                    if(result[i].budgetMonth == 9) {
                        result[i].budgetMonth = 'SEP';
                    }
                    if(result[i].budgetMonth == 10) {
                        result[i].budgetMonth = 'OCT';
                    }
                    if(result[i].budgetMonth == 11) {
                        result[i].budgetMonth = 'NOV';
                    }
                    if(result[i].budgetMonth == 12) {
                        result[i].budgetMonth = 'DEC';
                    }
                }
                AUIGrid.setGridData(myGridID, result);
            });
       });
        
        //아이템 grid 행 추가
        $("#addRow").click(function() { 
               var item = new Object();
               var month_int = 0;
               var month_val = "";
               var year_val ="";
               var monthRowCount = 0;
               var yearRowCount = 0;
               
               /*if($("#searchDt").val() != "" || $("searchDt").val() != null) {
                   item.budgetYear = $("#searchDt").val();
                   
               } else {*/
                   yearRowCount = AUIGrid.getRowCount(myGridID);
                   yearRowCount--;
                   
                   year_val = AUIGrid.getCellValue(myGridID, yearRowCount, "budgetYear");
                   item.budgetYear = year_val;
               
                //}
                       var monthRowCount = AUIGrid.getRowCount(myGridID);
                       monthRowCount--;
                       
                       month_val = AUIGrid.getCellValue(myGridID, monthRowCount, "budgetMonth");
                       
                       if(month_val == "JAN") {
                           month_int = 1;
                       } else if(month_val == "FEB") {
                           month_int = 2;
                       } else if(month_val == "MAR") {
                           month_int = 3;
                       } else if(month_val == "APR") {
                           month_int = 4;
                       } else if(month_val == "MAY") {
                           month_int = 5;
                       } else if(month_val == "JUN") {
                           month_int = 6;
                       } else if(month_val == "JUL") {
                           month_int = 7;
                       } else if(month_val == "AUG") {
                           month_int = 8;
                       } else if(month_val == "SEP") {
                           month_int = 9;
                       } else if(month_val == "OCT") {
                           month_int = 10;
                       } else if(month_val == "NOV") {
                           month_int = 11;
                       } else if(month_val == "DEC") {
                           month_int = 12;
                       }
                       
                       month = month_int + 1;
                       
                       var month_char = "";
                       if(month == 13) {
                          item.budgetYear = year_val + 1;
                       }
                       if(month == 1 || month == 13) {
                           month_char = 'JAN';
                       } else if(month == 2) {
                           month_char = 'FEB';
                       } else if(month == 3) {
                           month_char = 'MAR';
                       } else if(month == 4) {
                           month_char = 'APR';
                       } else if(month == 5) {
                           month_char = 'MAY';
                       } else if(month == 6) {
                           month_char = 'JUN';
                       } else if(month == 7) {
                           month_char = 'JUL';
                       } else if(month == 8) {
                           month_char = 'AUG';
                       } else if(month == 9) {
                           month_char = 'SEP';
                       } else if(month == 10) {
                           month_char = 'OCT';
                       } else if(month == 11) {
                           month_char = 'NOV';
                       } else if(month == 12) {
                           month_char = 'DEC';
                       }
                     
                       item.budgetMonth = month_char;
                       
                       AUIGrid.addRow(myGridID, item, "last");
                   });
      //save
         $("#save").click(function() {
          if (validation()) {
               Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveGridData);
            }
        }); 
      
    });//Ready
    
      function fn_saveGridData(){
            Common.ajax("POST", "/eAccounting/budget/saveBudgetSysMaintGrid.do", GridCommon.getEditData(myGridID), function(result) {
                // 공통 메세지 영역에 메세지 표시.
                Common.setMsg("<spring:message code='sys.msg.success'/>");
                $("#search").trigger("click");
            }, function(jqXHR, textStatus, errorThrown) {
                try {
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                } catch (e) {
                    console.log(e);
                }
                Common.alert("Fail : " + jqXHR.responseJSON.message);             
            });
        } 


    // 행 추가 이벤트 핸들러
    function auiAddRowHandler(event) {
    }
    // 행 삭제 이벤트 핸들러
    function auiRemoveRowHandler(event) {
    }


    /*  validation */
    function validation() {
        var result = true;
        var addList = AUIGrid.getAddedRowItems(myGridID);
        var udtList = AUIGrid.getEditedRowItems(myGridID);

        if (addList.length == 0 && udtList.length == 0) {
          Common.alert("<spring:message code='sys.common.alert.noChange'/>");
          return false;
        }
        if(!validationCom(addList) || !validationCom(udtList)){
            return false;
       }      
        return result;
      }  
    
     function validationCom(list){
         var result = true;
         for (var i = 0; i < list.length; i++) {
                var budgetYear = list[i].budgetYear;
                var budgetMonth = list[i].budgetMonth;
                var budgetStus = list[i].budgetStus;
               
                if (budgetYear == "") {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+bYear+"' htmlEscape='false'/>");
                  break;
                } else if (budgetMonth == "") {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+bMonth+"' htmlEscape='false'/>");
                  break;
                } else if (budgetStus == "undefined" || budgetStus == "" || budgetStus == null) {
                  result = false;
                  Common.alert("<spring:message code='sys.common.alert.validation' arguments='"+bStatus+"' htmlEscape='false'/>");
                  break;
                }
                 
         }
         return result;
     }
     
</script>


<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>eAccount</li>
    <li>Budget System Maintenance</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="budget.SysMaintenance" /></h2>

</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="listSForm" name="listSForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="budget.year" /></th>
    <td>
    <input type="text" id="searchDt" name="searchDt" title="" placeholder="" class="fl_left" />
     <p class="btn_blue"><a href="#"  id="search" ><span class="search"></span><spring:message code='sys.btn.search'/></span></a></p>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</form>
</section><!-- search_table end -->
<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow"><spring:message code="budget.add" /></a></p></li>
</ul>
<section class="search_result"><!-- search_result start -->
    
<article class="grid_wrap" onchange = "duplicationCheck();"><!-- grid_wrap start -->
    <div id="grid_wrap" style="width:100%; height:380px; margin:0 auto;" onclick="duplicationCheck()"></div>
</article><!-- grid_wrap end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save"><spring:message code='sys.btn.save'/></a></p></li>
</ul>
</section><!-- search_result end -->
</section><!-- content end -->