<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<article class="tap_area">
    <aside class="title_line">
        <h3>Advance Billing Remark (PO)</h3>
    </aside>

    <table class="type1">
        <caption>table</caption>
        <colgroup>
            <col style="width:165px" />
            <col style="width:*" />
        </colgroup>

        <tbody>
            <tr>
                <th scope="row">Reference No.<span class="must">*</span></th>
                <td>
                    <input type="text" id="advBilRemRefNo" name="advBilRemRefNo" title="Reference Number" placeholder="Reference Number" class="w100p" />
                </td>
            </tr>
            <tr>
                <th scope="row">Remark</th>
                <td>
                    <textarea cols="20" rows="5" id="advBilRemRemark" name="advBilRemRemark" title="Remark" placeholder="Remark"></textarea>
                </td>
            </tr>
            <tr>
                <th scope="row">Invoice Remark</th>
                <td>
                    <textarea cols="20" rows="5" id="advBilRemInvcRemark" name="advBilRemInvcRemark" title="Invoice Remark" placeholder="Invoice Remark"></textarea>
                </td>
            </tr>
        </tbody>
    </table>
</article>