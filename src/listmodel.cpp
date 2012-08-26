/*
 * Author: Christophe Dumez <dchris@gmail.com>
 * License: Public domain (No attribution required)
 * Website: http://cdumez.blogspot.com/
 * Version: 1.0
 */
#include "listmodel.h"
#include <QDebug>

ListModel::ListModel(ListItem* prototype, QObject *parent) :
    QAbstractListModel(parent), m_prototype(prototype)
{
  setRoleNames(m_prototype->roleNames());
}

int ListModel::rowCount(const QModelIndex &parent) const
{
  Q_UNUSED(parent);
  return m_list.size();
//    return this->count;
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
  if(index.row() < 0 || index.row() >= m_list.size())
    return QVariant();
  return m_list.at(index.row())->data(role);
}

ListModel::~ListModel() {
  delete m_prototype;
  clear();
}

void ListModel::appendRow(ListItem *item)
{
  appendRows(QList<ListItem*>() << item);
}

void ListModel::appendRows(const QList<ListItem *> &items)
{
  beginInsertRows(QModelIndex(), rowCount(), rowCount()+items.size()-1);
  foreach(ListItem *item, items) {
    connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
    m_list.append(item);
  }
  endInsertRows();
}

void ListModel::insertRow(int row, ListItem *item)
{
  beginInsertRows(QModelIndex(), row, row);
  connect(item, SIGNAL(dataChanged()), SLOT(handleItemChange()));
  m_list.insert(row, item);
  endInsertRows();
}

void ListModel::handleItemChange()
{
  ListItem* item = static_cast<ListItem*>(sender());
  QModelIndex index = indexFromItem(item);
  if(index.isValid())
    emit dataChanged(index, index);
}

ListItem * ListModel::find(const QString &id) const
{
  foreach(ListItem* item, m_list) {
    if(item->id() == id) return item;
  }
  return 0;
}

QModelIndex ListModel::indexFromItem(const ListItem *item) const
{
  Q_ASSERT(item);
  for(int row=0; row<m_list.size(); ++row) {
    if(m_list.at(row) == item) return index(row);
  }
  return QModelIndex();
}

void ListModel::clear()
{
  qDeleteAll(m_list);
  m_list.clear();
}

bool ListModel::removeRow(int row, const QModelIndex &parent)
{
  Q_UNUSED(parent);
  if(row < 0 || row >= m_list.size()) return false;
  beginRemoveRows(QModelIndex(), row, row);
  delete m_list.takeAt(row);
  endRemoveRows();
  return true;
}

bool ListModel::removeRows(int row, int count, const QModelIndex &parent)
{
  Q_UNUSED(parent);
  if(row < 0 || (row+count) >= m_list.size()) return false;
  beginRemoveRows(QModelIndex(), row, row+count-1);
  for(int i=0; i<count; ++i) {
    delete m_list.takeAt(row);
  }
  endRemoveRows();
  return true;
}

ListItem * ListModel::takeRow(int row)
{
  beginRemoveRows(QModelIndex(), row, row);
  ListItem* item = m_list.takeAt(row);
  endRemoveRows();
  return item;
}

void ListModel::positionChanged(const double latitude, const double longitude, const double hAccuracy)
{
    foreach (ListItem* obj, m_list) {
         obj->calculateDistance(latitude, longitude, hAccuracy);
    }
    emit dataChanged(index(0, 1), index(m_list.size()-1, 2));
    // now sort our list model
    sort();
}

void ListModel::clearAll() {
    if (m_list.isEmpty()) return;

    qDebug() << "Removing all items from model; Current size is" << m_list.count();
    beginRemoveRows(QModelIndex(), 0, m_list.size()-1);
    qDeleteAll(m_list);
    m_list.clear();
    endRemoveRows();
    qDebug() << "All items removed";
}

QVariant ListModel::get(int row)
{
    ListItem * item = m_list.at(row);
    QMap<QString, QVariant> itemData;
    QHashIterator<int, QByteArray> hashItr(item->roleNames());
    while(hashItr.hasNext()){
        hashItr.next();
        itemData.insert(hashItr.value(),item->data(hashItr.key()).toString());
    }
    return QVariant(itemData);
}

bool ListModel::itemLessThan(const QPair<ListItem*,int> &left,
                              const QPair<ListItem*,int> &right)
{
    return (left.first->data(Qt::UserRole+1).toDouble() < right.first->data(Qt::UserRole+1).toDouble());
}

void ListModel::sort()
{
    emit layoutAboutToBeChanged();

    QVector < QPair<ListItem*,int> > sorting(m_list.count());
    for (int i = 0; i < m_list.count(); ++i) {
        ListItem *item = m_list.at(i);
        sorting[i].first = item;
        sorting[i].second = i;
    }

    qSort(sorting.begin(), sorting.end(), itemLessThan);

    QModelIndexList fromIndexes;
    QModelIndexList toIndexes;
    for (int r = 0; r < sorting.count(); ++r) {
        ListItem *item = sorting.at(r).first;
        toIndexes.append(createIndex(r, 0, item));
        fromIndexes.append(createIndex(sorting.at(r).second, 0, sorting.at(r).first));
        m_list[r] = sorting.at(r).first;
    }
    changePersistentIndexList(fromIndexes, toIndexes);

    emit layoutChanged();
}

//bool ListModel::canFetchMore(const QModelIndex & /* index */) const
// {
//    qDebug() << "canFetchMore is called";

//    if (this->count < m_list.size())
//         return true;
//     else
//         return false;
// }

// void ListModel::fetchMore(const QModelIndex & /* index */)
// {
//     int remainder = m_list.size() - this->count;
//     int itemsToFetch = qMin(30, remainder);

//     beginInsertRows(QModelIndex(), this->count, this->count + itemsToFetch-1);

//     this->count += itemsToFetch;

//     endInsertRows();

//     qDebug() << "fetchMore is called with itemsToFetch:" << itemsToFetch;
//     qDebug() << "fetchMore is called with m_list.size():" << remainder;

//     emit numberPopulated(itemsToFetch);
// }
