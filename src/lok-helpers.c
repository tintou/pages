/*-
 * Copyright 2019 Corentin Noël
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: Corentin Noël <corentin@elementary.io>
 */

#include "lok-helpers.h"

gchar *
lok_doc_view_get_command_values (LOKDocView* pDocView, const gchar *command)
{
  LibreOfficeKitDocument* pDocument;
  LibreOfficeKitDocumentClass *pClass;

  g_assert (LOK_IS_DOC_VIEW (pDocView));

  pDocument = lok_doc_view_get_document(pDocView);
  pClass = pDocument->pClass;
  return pClass->getCommandValues(pDocument, command);
}
